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
    private let pictureJsonURL = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"
    
    let config = Realm.Configuration(schemaVersion: 3)
    let memoConfig = Realm.Configuration(inMemoryIdentifier: "memo")
    
    public static let shared: RealmController = {
        let realmController = RealmController()
        return realmController
    }()
    
    public static var preview: RealmController = {
        let realmController = RealmController()
        if let chapters: [JChapter] = load("example.json",bundel: .swiftUIPreviewsCompatibleModule){
            realmController.syncFromServer(chapters: chapters)
        }
        return realmController
    }()
    
    init(){
        do{
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
            memoRealm = try Realm(configuration: memoConfig)
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
    }
    
    // 清除所有本地数据
    func cleanRealm(){
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
                                            deleteWord(word: lword)
                                        }
                                    }
                                }else{
                                    deletePictureFiles(picture: lpictureFile)
                                }
                            }
                        }else{
                            deleteTopic(topic: ltopic)
                        }
                    }
                }else{
                    //服务器上没有这个chapter
                    deleteChapter(chapter: lchapter)
                }
            }
        }
    }
    
    // 删除数据库中指定的chapter记录
    private func deleteChapter(chapter: Chapter) {
        if let localRealm = localRealm {
            do{
                for topic in chapter.topics{
                    deleteTopic(topic: topic)
                }
                try localRealm.write{
                    localRealm.delete(chapter)
                }
            } catch {
                logger.error("Error deleting chapter \(chapter) from Realm: \(error.localizedDescription)")
            }
        }
    }
    
    // 删除数据库中指定的topic记录
    private func deleteTopic(topic: Topic) {
        if let localRealm = localRealm {
            do{
                try localRealm.write{
                    localRealm.delete(topic.pictures)
                    localRealm.delete(topic)
                }
            } catch {
                logger.error("Error deleting topic \(topic) from Realm: \(error.localizedDescription)")
            }
        }
    }
    
    // 删除数据中指定的word记录
    private func deleteWord(word: Word){
        if let localRealm = localRealm {
            do{
                try localRealm.write{
                    localRealm.delete(word)
                }
            } catch {
                logger.error("Error deleting Word \(word) from Realm: \(error.localizedDescription)")
            }
        }
    }
    
    // 删除数据库中指定的picture记录
    private func deletePictureFiles(picture: Picture){
        if let localRealm = localRealm {
            do{
                try localRealm.write{
                    localRealm.delete(picture)
                }
            } catch {
                logger.error("Error deleting pictureFiles \(picture) from Realm: \(error.localizedDescription)")
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
                                                    pictureFile.words.append(genWord(word: qword))
                                                }
                                            }
                                        }else{
                                            // 增加对应的pictureFile
                                            let newPictureFile = genPicture(pictureFile: qpictureFile)
                                            topic.pictures.append(newPictureFile)
                                        }
                                    }
                                }else{
                                    // 不存在这个topic
                                    let newTopic = genTopic(topic: qtopic)
                                    chapter.topics.append(newTopic)
                                }
                            }
                        }else{
                            //不存在chapter
                            let newChapter = Chapter(value: [
                                "name" : qchapter.name
                            ])
                            for topic in qchapter.topics{
                                let newTopic = genTopic(topic: topic)
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
            let newPicture = genPicture(pictureFile: pictureFile)
            newTopic.pictures.append(newPicture)
        }
        return newTopic
    }
    
    private func genPicture ( pictureFile: JPictureFile ) -> Picture{
        let newPictureFile = Picture(value: [
            "name" : pictureFile.name
        ])
        for word in pictureFile.words{
            let newWord = genWord(word: word)
            newPictureFile.words.append(newWord)
        }
        return newPictureFile
    }
    
    private func genWord(word: String) -> Word{
        let newWord = Word(value: [
            "name": word
        ])
        return newWord
    }
}
