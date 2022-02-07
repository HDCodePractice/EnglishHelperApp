//
//  RealmManager.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-02.
//

import Foundation
import RealmSwift

class RealmManager{
    private(set) var localRealm : Realm?
    private(set) var memoRealm : Realm?
    static let instance = RealmManager()
    let config = Realm.Configuration(schemaVersion: 2)
    let memoConfig = Realm.Configuration(inMemoryIdentifier: "memo")
    
    init(){
        openRealm()
    }
    
    func openRealm(){
        do{
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
            memoRealm = try Realm(configuration: memoConfig)
        } catch {
            print("Error opening Realm:\(error)")
        }
    }
    
    func genExamRealm(){
        if let localRealm = localRealm , let memoRealm = memoRealm {
            let chapters = localRealm.objects(LocalChapter.self).where{
                $0.isSelect == true
            }
            
            try! memoRealm.write{
                memoRealm.deleteAll()
                for chapter in chapters{
                    memoRealm.create(LocalChapter.self, value: chapter)
                }
                let noSelectPictureFile = memoRealm.objects(LocalPictureFile.self).where{
                    $0.assignee.isSelect == false
                }
                memoRealm.delete(noSelectPictureFile)
                let noSelectTopics = memoRealm.objects(LocalTopic.self).where{
                    $0.isSelect == false
                }
                memoRealm.delete(noSelectTopics)
            }
        }
    }
    
    func getRandomExam(answerLength : Int) -> PictureExam.Result?{
        if let memoRealm = memoRealm,
           let pictureFile = memoRealm.objects(LocalPictureFile.self).randomElement(){
            let assignee = pictureFile.assignee.first
            var answers = Array(assignee!.pictureFiles.where({ $0.id != pictureFile.id }).shuffled().prefix(answerLength-1))
            answers.append(pictureFile)
            answers.shuffle()
            
            if let questionWord = pictureFile.words.shuffled().first,
               let correctAnswer = answers.firstIndex(of: pictureFile),
               let topic = pictureFile.assignee.first,
               let chapter = topic.assignee.first{
                return PictureExam.Result(
                    questionWord: questionWord,
                    correctAnswer: correctAnswer,
                    answers: answers,
                    topic: topic.name,
                    chapter: chapter.name)
            }
        }
        return nil
    }
    
    func cleanRealm(){
        if let localRealm = localRealm {
            do{
                try localRealm.write{
                    localRealm.deleteAll()
                }
            } catch {
                print("clean realm Error: \(error)")
            }
            
        }
    }
    
    private func getLocalPictureFile ( pictureFile:PictureFile ) -> LocalPictureFile{
        let newPictureFile = LocalPictureFile(value: [
            "name" : pictureFile.name,
            "words" : pictureFile.words
        ])
        return newPictureFile
    }
    
    private func getLocalTopic ( topic: Topic ) -> LocalTopic{
        let newTopic = LocalTopic(value: [
            "name" : topic.name
        ])
        for pictureFile in topic.pictureFiles{
            let newPictureFile = getLocalPictureFile(pictureFile: pictureFile)
            newTopic.pictureFiles.append(newPictureFile)
        }
        return newTopic
    }
    
    private func findChapterInChapters(name:String , chapters:[Chapter]) -> Chapter?{
        for chapter in chapters{
            if chapter.name == name{
                return chapter
            }
        }
        return nil
    }
    
    private func findTopicInTopics(name:String , topics:[Topic]) -> Topic?{
        for topic in topics{
            if topic.name == name{
                return topic
            }
        }
        return nil
    }
    
    private func findPictureFiles(name:String , pictureFiles:[PictureFile]) -> PictureFile?{
        for pictureFile in pictureFiles{
            if pictureFile.name == name{
                return pictureFile
            }
        }
        return nil
    }
    
    private func deleteTopic(topic: LocalTopic) {
        if let localRealm = localRealm {
            do{
                try localRealm.write{
                    // topic.pictureFiles.removeAll()
                    localRealm.delete(topic.pictureFiles)
                    localRealm.delete(topic)
                }
            } catch {
                print("Error deleting topic \(topic) from Realm: \(error)")
            }
        }
    }
    
    private func deleteChapter(chapter: LocalChapter) {
        if let localRealm = localRealm {
            do{
                for topic in chapter.topics{
                    deleteTopic(topic: topic)
                }
                try localRealm.write{
                    localRealm.delete(chapter)
                }
            } catch {
                print("Error deleting chapter \(chapter) from Realm: \(error)")
            }
        }
    }
    
    private func deletePictureFiles(pictureFiles: LocalPictureFile){
        if let localRealm = localRealm {
            do{
                try localRealm.write{
                    localRealm.delete(pictureFiles)
                }
            } catch {
                print("Error deleting pictureFiles \(pictureFiles) from Realm: \(error)")
            }
        }
    }
    
    private func removeFromSwerver(chapters:[Chapter]){
        if let localRealm = localRealm {
            let dbChapters = localRealm.objects(LocalChapter.self)
            for lchapter in dbChapters{
                if let rchapter = findChapterInChapters(name: lchapter.name, chapters: chapters){
                    // 服务器上有chapter
                    for ltopic in lchapter.topics{
                        if let rtopic = findTopicInTopics(name: ltopic.name, topics: rchapter.topics){
                            // 服务器上有topic
                            for lpictureFile in ltopic.pictureFiles{
                                if findPictureFiles(name: lpictureFile.name, pictureFiles: rtopic.pictureFiles) == nil{
                                    deletePictureFiles(pictureFiles: lpictureFile)
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
    
    func syncFromServer(chapters:[Chapter]){
        if let localRealm = localRealm {
            do {
                try localRealm.write{
                    // foreach出server上的所有chapter
                    for qchapter in chapters {
                        let dbChapters = localRealm.objects(LocalChapter.self).where{
                            $0.name == qchapter.name
                        }
                        if let chapter = dbChapters.first {
                            //数据库里有chapter
                            for qtopic in qchapter.topics{
                                let dbTopics = localRealm.objects(LocalTopic.self).where{
                                    $0.name == qtopic.name
                                }
                                if let topic = dbTopics.first{
                                    // 数据库里存在对应的topic
                                    for qpictureFile in qtopic.pictureFiles{
                                        let dbPictureFiles = localRealm.objects(LocalPictureFile.self).where{
                                            $0.name == qpictureFile.name
                                        }
                                        if let pictureFile = dbPictureFiles.first {
                                            // 数据库里存在对应的pictureFile
                                            pictureFile.words.removeAll()
                                            pictureFile.words.append(objectsIn: qpictureFile.words)
                                        }else{
                                            // 增加对应的pictureFile
                                            let newPictureFile = getLocalPictureFile(pictureFile: qpictureFile)
                                            topic.pictureFiles.append(newPictureFile)
                                        }
                                    }
                                }else{
                                    // 不存在这个topic
                                    let newTopic = getLocalTopic(topic: qtopic)
                                    chapter.topics.append(newTopic)
                                }
                            }
                        }else{
                            //不存在chapter
                            let newChapter = LocalChapter(value: [
                                "name" : qchapter.name
                            ])
                            for topic in qchapter.topics{
                                let newTopic = getLocalTopic(topic: topic)
                                newChapter.topics.append(newTopic)
                            }
                            localRealm.add(newChapter)
                        }
                    }
                }
                removeFromSwerver(chapters: chapters)
            } catch {
                print("Error syncing to Realm:\(error)")
            }
        }
    }
    
    func toggleChapter(chapter: LocalChapter){
        if let localRealm = localRealm {
            do{
                if let chapter = chapter.thaw(){
                    try localRealm.write{
                        chapter.isSelect.toggle()
                        for topic in chapter.topics{
                            if topic.isSelect != chapter.isSelect {
                                topic.isSelect = chapter.isSelect
                            }
                        }
                    }
                }
            }catch{
                print("toggle chapter \(chapter) error: \(error)")
            }
        }
    }
    
    // toggle一个Topic的isSelect
    func toggleTopic(topic: LocalTopic){
        if let localRealm = localRealm {
            do{
                if let topic = topic.thaw() , let chapter = topic.assignee.first{
                    try localRealm.write{
                        topic.isSelect.toggle()
                        // 如果chapter没选，顺便选上
                        if topic.isSelect && !chapter.isSelect{
                            chapter.isSelect = true
                            return
                        }
                        // 如果chapter选上了，查看是不是所有的都是没选中的，如果都没选，chapter也取消选择
                        if chapter.isSelect{
                            for t in chapter.topics{
                                if t.isSelect{
                                    return
                                }
                            }
                            // 所有子项都没选择，把chapter也取消选择
                            chapter.isSelect = false
                        }
                    }
                }
            }catch{
                print("toggle topict \(topic) error:\(error)")
            }
        }
    }
    
    func mokeData() -> LocalChapter?{
        if let localRealm = localRealm{
            let allChapter = localRealm.objects(LocalChapter.self)
            return allChapter.first
        }
        return nil
    }
    
    func getAllChapters() -> [LocalChapter]{
        if let localRealm = localRealm {
            let allChapters = localRealm.objects(LocalChapter.self)
            var chapters : [LocalChapter] = []
            allChapters.forEach{ chapter in
                chapters.append(chapter)
            }
            return chapters
        }
        return []
    }
    
    //    func addTopic(topicName: String){
    //        if let localRealm = localRealm {
    //            do{
    //                try localRealm.write{
    //                    let newTopic = LocalTopic(value: [
    //                        "name": topicName
    //                    ])
    //                    localRealm.add(newTopic)
    //                    getTopics()
    //                    print("Added new topic to Realm: \(newTopic)")
    //                }
    //            } catch {
    //                print("Error adding topic to Realm:\(error)")
    //            }
    //        }
    //    }
    //
    //
    //    func updateTopic(id: ObjectId, name: String? , isSelect: Bool?){
    //        if let localRealm = localRealm {
    //            do{
    //                let topicToUpdate = localRealm.objects(LocalTopic.self).filter(NSPredicate(format: "id == @%", id))
    //                guard !topicToUpdate.isEmpty else { return }
    //                try localRealm.write{
    //                    var updatemsg = ""
    //                    if let name = name {
    //                        topicToUpdate[0].name = name
    //                        updatemsg += "name: \(name) "
    //                    }
    //                    if let isSelect = isSelect {
    //                        topicToUpdate[0].isSelect = isSelect
    //                        updatemsg += "isSelect: \(isSelect) "
    //                    }
    //                    getTopics()
    //                    print("Updated topic with id \(id)! \(updatemsg)")
    //                }
    //            } catch{
    //                print("Error updating topic \(id) to Realm: \(error)")
    //            }
    //        }
    //    }
    
    //    func deleteTopic(id: ObjectId) {
    //        if let localRealm = localRealm {
    //            do{
    //                let topicToDelete = localRealm.objects(LocalTopic.self).filter(NSPredicate(format: "id == @%", id))
    //                guard !topicToDelete.isEmpty else { return }
    //
    //                try localRealm.write{
    //                    localRealm.delete(topicToDelete)
    //                    getTopics()
    //                    print("Deleted topic with id \(id)")
    //                }
    //
    //            } catch {
    //                print("Error deleting topic \(id) from Realm: \(error)")
    //            }
    //        }
    //    }
}
