//
//  File.swift
//  
//
//  Created by 老房东 on 2022-04-19.
//

import Foundation
import RealmSwift
import OSLog
import UIKit

public class RealmController{
    public var localRealm : Realm?
    public var memoRealm : Realm?
    private let logger = Logger()
    private let pictureJsonURL="https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"
    private let iVerbsJsonURL="https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/iverbs.json"
    
    let config = Realm.Configuration(
        schemaVersion: 9,
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 9{
                let types = [Picture.className(),Word.className()]
                for type in types {
                    // 老板本的ID是在每台设备上都不相同的，所以只能放弃重新完全从服务器上进行一次同步了
                    migration.enumerateObjects(ofType: type) { oldObject, newObject in
                        if let newObject = newObject{
                            migration.delete(newObject)
                        }
                    }
                }
            }
        }
    )
    let memoConfig = Realm.Configuration(inMemoryIdentifier: "memo")
    // 可以使用这个配置来将内存放在磁盘上进行观察
//    let memoConfig : Realm.Configuration = {
//        var config = Realm.Configuration.defaultConfiguration
//        config.fileURL!.deleteLastPathComponent()
//        config.fileURL!.appendPathComponent("memo")
//        config.fileURL!.appendPathExtension("realm")
//        return config
//    }()
    
    public var realmFilePath: String{
        if let localRealm = localRealm, let url = localRealm.configuration.fileURL{
            return url.path
        }
        return "NoRealmFile"
    }
    
    public static let shared: RealmController = {
        let realmController = RealmController()
        return realmController
    }()
    
    public static var preview: RealmController = {
        let realmController = RealmController()
        realmController.reloadPreviewData()
        return realmController
    }()
    
    public func reloadPreviewData(jsonFile:String="example.json"){
        if let chapters: [JChapter] = load(jsonFile,bundel: .swiftUIPreviewsCompatibleModule){
            syncFromServer(chapters: chapters)
        }
        
        let data: Data
        
        do {
            data = try Data(contentsOf: URL(string: iVerbsJsonURL)!)
            if let jsons = try! JSONSerialization.jsonObject(with: data, options: []) as? [Any], let localRealm=localRealm{
                try localRealm.write{
                    let irregularVerbs = localRealm.objects(IrregularVerb.self)
                    localRealm.delete(irregularVerbs)
                    for i in 0..<jsons.count {
                        localRealm.create(IrregularVerb.self, value: jsons[i], update: .modified)
                    }
                }
            }
        } catch {
            print("\(error)")
            
        }
        
    }
    
    init(){
        do{
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
            memoRealm = try Realm(configuration: memoConfig)
#if DEBUG
            print(realmFilePath)
#endif
        }catch{
            logger.error("Error opening Realm:\(error.localizedDescription)")
        }
    }
        
    // 从服务器上同步JSON数据到本地数据库
    @MainActor
    public func fetchData() async{
        if let jChapter:[JChapter] = await loadDataByServer(url: pictureJsonURL){
            syncFromServer(chapters: jChapter)
        }
        do{
            let (data,_) = try await URLSession.shared.data(from: URL(string: iVerbsJsonURL)!)
            if let jsons = try! JSONSerialization.jsonObject(with: data, options: []) as? [Any], let localRealm=localRealm{
                localRealm.writeAsync{
                    let irregularVerbs = localRealm.objects(IrregularVerb.self)
                    localRealm.delete(irregularVerbs)
                    for i in 0..<jsons.count {
                        localRealm.create(IrregularVerb.self, value: jsons[i], update: .modified)
                    }
                }onComplete: { error in
                    if let error=error{
                        Logger().error("create IrregularVery erryr:\(error.localizedDescription)")
                    }
                }
            }
        }catch{
            Logger().error("load \(self.iVerbsJsonURL) error:\(error.localizedDescription)")
        }
    }
    
    // 清除所有本地数据
    public func cleanRealm(){
        if let localRealm = localRealm {
            do{
                try localRealm.write{
                    localRealm.deleteAll()
                }
            } catch {
                logger.error("clean realm Error: \(error.localizedDescription)")
            }
        }
    }
    
    // 得到所有的chapter数据
    func getAllChapters() -> [Chapter]{
        if let localRealm = localRealm {
            let allChapters = localRealm.objects(Chapter.self)
            var chapters = [Chapter]()
            allChapters.forEach{ chapter in
                chapters.append(chapter)
            }
            return chapters
        }
        return []
    }
    
    // 将服务器上不存在的数据清除
    private func removeFromServer(chapters:[JChapter]){
        if let localRealm = localRealm {
            let dbChapters = localRealm.objects(Chapter.self)
            for lchapter in dbChapters{
                if let rchapter = findChapterInChapters(name: lchapter.name, chapters: chapters){
                    // 服务器上有chapter
                    for ltopic in lchapter.topics{
                        if let rtopic = findTopicInTopics(name: ltopic.name, topics: rchapter.topics){
                            // 服务器上有topic
                            for lpictureFile in ltopic.pictures{
                                if let rpictureFile = findPictureFiles(name: lpictureFile.name, pictureFiles: rtopic.pictureFiles){
                                    // 服务器上有picture
                                    for lword in lpictureFile.words{
                                        if findWords(name: lword.name, words: rpictureFile.words) == nil{
                                            lword.delete()
                                        }
                                    }
                                }else{
                                    lpictureFile.delete()
                                }
                            }
                        }else{
                            ltopic.delete()
                        }
                    }
                }else{
                    //服务器上没有这个chapter
                    lchapter.delete()
                }
            }
            // 清除没有任何指向的words
            let lwords = localRealm.objects(Word.self).where {
                $0.assignee.count==0
            }
            do{
                try localRealm.write{
                    localRealm.delete(lwords)
                }
            } catch {
                logger.error("Error deleting Word from Realm: \(error.localizedDescription)")
            }
        }
    }
    
    // 查找JSON中是否包括name的chapter
    private func findChapterInChapters(name:String , chapters:[JChapter]) -> JChapter?{
        for chapter in chapters{
            if chapter.name == name{
                return chapter
            }
        }
        return nil
    }
    
    // 查找JSON中是否包括name的topic
    private func findTopicInTopics(name:String , topics:[JTopic]) -> JTopic?{
        for topic in topics{
            if topic.name == name{
                return topic
            }
        }
        return nil
    }
    
    // 查找JSON中是否包括name的Word
    private func findWords(name:String, words:[String]) -> String?{
        for word in words{
            if word == name {
                return word
            }
        }
        return nil
    }
    
    // 查找JSON中是否包括name的PictureFiles
    private func findPictureFiles(name:String , pictureFiles:[JPictureFile]) -> JPictureFile?{
        for pictureFile in pictureFiles{
            if pictureFile.name == name{
                return pictureFile
            }
        }
        return nil
    }
    
    // 从JSON中同步数据到本地数据库中
    func syncFromServer(chapters:[JChapter]){
        if let localRealm = localRealm {
            do {
                try localRealm.write{
                    // foreach出server上的所有chapter
                    for qchapter in chapters {
                        let dbChapters = localRealm.objects(Chapter.self).where{
                            $0.name == qchapter.name
                        }
                        if let chapter = dbChapters.first {
                            //数据库里有chapter
                            for qtopic in qchapter.topics{
                                let dbTopics = localRealm.objects(Topic.self).where{
                                    $0.name == qtopic.name
                                }
                                if let topic = dbTopics.first{
                                    // 数据库里存在对应的topic
                                    for qpictureFile in qtopic.pictureFiles{
                                        let dbPictureFiles = localRealm.objects(Picture.self).where{
                                            $0.name == qpictureFile.name
                                        }
                                        if let pictureFile = dbPictureFiles.first {
                                            // 数据库里存在对应的pictureFile
                                            for qword in qpictureFile.words{
                                                let dbwords = localRealm.objects(Word.self).where{
                                                    $0.name == qword
                                                }
                                                if dbwords.count == 0{
                                                    let wid = "\(pictureFile.id)|\(qword)"
                                                    pictureFile.words.append(self.genWord(word: qword,id: wid))
                                                }
                                            }
                                        }else{
                                            // 增加对应的pictureFile
                                            let newPictureFile = self.genPicture(pictureFile: qpictureFile, id: "\(qtopic.name)|\(qpictureFile.name)")
                                            topic.pictures.append(newPictureFile)
                                        }
                                    }
                                }else{
                                    // 不存在这个topic
                                    let newTopic = self.genTopic(topic: qtopic)
                                    chapter.topics.append(newTopic)
                                }
                            }
                        }else{
                            //不存在chapter
                            let newChapter = Chapter(value: [
                                "name" : qchapter.name
                            ])
                            for topic in qchapter.topics{
                                let newTopic = self.genTopic(topic: topic)
                                newChapter.topics.append(newTopic)
                            }
                            localRealm.add(newChapter)
                        }
                    }
                }
                removeFromServer(chapters: chapters)
            } catch {
                logger.error("Error syncing to Realm:\(error.localizedDescription)")
            }
        }
    }
    
    private func genTopic(topic: JTopic ) -> Topic{
        let newTopic = Topic(value: [
            "name" : topic.name
        ])
        for pictureFile in topic.pictureFiles{
            let newPicture = genPicture(pictureFile: pictureFile, id: "\(topic.name)|\(pictureFile.name)")
            newTopic.pictures.append(newPicture)
        }
        return newTopic
    }
    
    private func genPicture ( pictureFile: JPictureFile,id: String) -> Picture{
        let newPictureFile = Picture(value: [
            "id": id.sha256(),
            "name": pictureFile.name
        ])
        for word in pictureFile.words{
            let wid = "\(id.sha256())|\(word)"
            let newWord = genWord(word: word,id: wid)
            newPictureFile.words.append(newWord)
        }
        return newPictureFile
    }
    
    private func genWord(word: String,id: String) -> Word{
        let newWord = Word(value: [
            "id": id.sha256(),
            "name": word
        ])
        return newWord
    }
}
