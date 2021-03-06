//
//  RealmManager.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-02.
//

import Foundation
import RealmSwift

class RealmManager{
    private var localRealm : Realm?
    private var memoRealm : Realm?
    private(set) var memoRealmWordCount : Int = 0
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
    
    // 以localRealm中的数据为基础，生成用户选择的临时内存数据库memoRealm
    func genExamRealm(){
        memoRealmWordCount = 0
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
            let pfs = memoRealm.objects(LocalPictureFile.self)
            for pf in pfs{
                memoRealmWordCount += pf.words.count
            }
        }
    }
    
    func genWords(lenght: Int)->[String]{
        genExamRealm()
        if let memoRealm = memoRealm{
            let pictureFiles = memoRealm.objects(LocalPictureFile.self).shuffled().prefix(lenght)
            var words = [String]()
            for pf in pictureFiles{
                if let word = pf.words.randomElement(){
                    words.append(word)
                }
            }
            return words
        }
        return []
    }
    
    /*
     * 使用一条LocalPicturefile从localRealm中生成一个PictureExam.Result
     */
    private func fromLocalPictureFileGenExam(pictureFile: LocalPictureFile ,answerLength : Int) -> PictureExam.Result?{
        if let localRealm = localRealm {
            if let topicName = pictureFile.assignee.first?.name {
                if let topic = localRealm.objects(LocalTopic.self).where({$0.name == topicName}).first{
                    var answers = Array(topic.pictureFiles.where({$0.name != pictureFile.name}).shuffled().prefix(answerLength-1))
                    answers.append(pictureFile)
                    answers.shuffle()
                    
                    if let questionWord = pictureFile.words.shuffled().first,
                       let correctAnswer = answers.firstIndex(of: pictureFile),
                       let topic = pictureFile.assignee.first,
                       let chapter = topic.assignee.first{
                        
                        return PictureExam.Result(
                            questionWord: questionWord,
                            correctAnswer: correctAnswer,
                            answers: localPictureFilesToPictureFiles(lPictureFiles: answers),
                            topic: topic.name,
                            chapter: chapter.name)
                    }
                }
            }
        }
        return nil
    }
    
    /*
     * 以现有memoRealm中的数据为基础，生成一个随机的问题
     */
    func getRandomExam(answerLength : Int) -> PictureExam.Result?{
        if let memoRealm = memoRealm,
           let pictureFile = memoRealm.objects(LocalPictureFile.self).randomElement(){
            let exam = fromLocalPictureFileGenExam(pictureFile: pictureFile, answerLength: answerLength)
            return exam
        }
        return nil
    }
    
    private func localPictureFilesToPictureFiles(lPictureFiles: [LocalPictureFile]) -> [PictureFile]{
        var pictureFiles = [PictureFile]()
        for lpf in lPictureFiles{
            pictureFiles.append(lpf.toPictureFile())
        }
        return pictureFiles
    }
    
    /*
     * 生成独一无二的一道Exam，注意，在执行前务必调用
     * genExamRealm 生成题目源
     */
    func getUniqExam(answerLength : Int) -> PictureExam.Result?{
        if let memoRealm = memoRealm {
            if let pictureFile = memoRealm.objects(LocalPictureFile.self).randomElement(),
               let exam = fromLocalPictureFileGenExam(pictureFile: pictureFile, answerLength: answerLength){
                if pictureFile.words.count < 2 {
                    try! memoRealm.write{
                        memoRealm.delete(pictureFile)
                    }
                }else{
                    try! memoRealm.write{
                        if let index = pictureFile.words.firstIndex(of: exam.questionWord){
                            pictureFile.words.remove(at: index)
                        }
                    }
                }
                return exam
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
    
    /*
     * 将pictureFileName的words中的word清除，如果只有唯一的一个word了，将对应的pictureFile清除
     * 用于答对题目时，将已经对的单词从要记忆的单词库中去除
     */
    func deleteMemoRealmWord(word: String,pictureFileName: String) {
        if let memoRealm = memoRealm {
            let pictureFiles = memoRealm.objects(LocalPictureFile.self).where{
                $0.name == pictureFileName
            }
            if let pictureFile = pictureFiles.first{
                if pictureFile.words.contains(word){
                    do{
                        try memoRealm.write{
                            if pictureFile.words.count == 1{
                                memoRealm.delete(pictureFile)
                            }else{
                                if let i = pictureFile.words.firstIndex(of: word){
                                    pictureFile.words.remove(at: i)
                                }
                            }
                        }
                        let pfs = memoRealm.objects(LocalPictureFile.self)
                        memoRealmWordCount = 0
                        for pf in pfs{
                            memoRealmWordCount += pf.words.count
                        }
                    } catch {
                        print("Error deleting word \(word) from Realm: \(error)")
                    }
                }
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
