//
//  File.swift
//  
//
//  Created by Lei Zhou on 3/6/22.
//

import SwiftUI
import CommomLibrary
import RealmSwift
import OSLog

class PictureGameViewModel: ObservableObject{
    private var realmController : RealmController
    private let answerLength = 6
    
    @Published var gameStatus : GameStatus = .start
    @AppStorage(UserDefaults.UserDefaultsKeys.isAutoPronounce.rawValue) var isAutoPronounce = true
    @Published var gameMode = GameMode.finish
    @Published var length = 10
    
    @Published private(set) var index = 0
    @Published private(set) var score = 0
    @Published private(set) var reachedEnd = false
    
    @Published var answerSelected = false
    
    @Published private(set) var question : String = ""
    @Published private(set) var answerChoices: [Answer] = []
    @Published private(set) var audioFile : String = ""
    
    init(isPreview:Bool=false){
        if isPreview{
            realmController = RealmController.preview
        }else{
            realmController = RealmController.shared
        }
    }
    
    @MainActor
    func fetchData() async{
        await realmController.fetchData()
    }
    
    func cleanRealm(){
        realmController.cleanRealm()
    }
    
    func reloadPreviewData(jsonFile:String="example.json"){
        realmController.reloadPreviewData(jsonFile:jsonFile)
    }
    
    func generatePictureExam(){
        guard let localRealm = realmController.localRealm , let memoRealm = realmController.memoRealm else{
            return
        }
        
        var memoRealmWordCount = 0
        let chapters = localRealm.objects(Chapter.self).where{
            $0.isSelect == true
        }
        
        try! memoRealm.write{
            memoRealm.deleteAll()
            for chapter in chapters{
                memoRealm.create(Chapter.self, value: chapter)
            }
            
            let noSelectWords = memoRealm.objects(Word.self).where { word in
                word.assignee.assignee.isSelect == false
            }
            memoRealm.delete(noSelectWords)
            
            let noSelectPictureFiles = memoRealm.objects(Picture.self).where{
                $0.assignee.isSelect == false
            }
            memoRealm.delete(noSelectPictureFiles)
            
            let noSelectTopics = memoRealm.objects(Topic.self).where{
                $0.isSelect == false
            }
            memoRealm.delete(noSelectTopics)
        }
        memoRealmWordCount = memoRealm.objects(Word.self).count
        
        switch gameMode {
        case .uniq:
            if memoRealmWordCount < length{
                length = memoRealmWordCount
            }
        case .random:
            // 不做任何事
            length = length
        case .finish:
            length = memoRealmWordCount
        }
        
        if length == 0 {
            return
        }
        reachedEnd = false
        index = 0
        score = 0
        
        setQuestion()
        gameStatus = .inProgress
    }
    
    func setQuestion(){
        if index < length{
            var currentQuestion : PictureExam.Result?
            //            switch gameMode {
            //                    case .uniq:
            //                        currentQuestion = realmManager.getUniqExam(answerLength: answerLength)
            //                    case .random:
            //                        currentQuestion = realmManager.getRandomExam(answerLength: answerLength)
            //                    case .finish:
            //                        currentQuestion = realmManager.getRandomExam(answerLength: answerLength)
            //                    }
            currentQuestion = getRandomExam(answerLength: answerLength)
            if let currentQuestion = currentQuestion {
                question = currentQuestion.questionWord
                answerChoices = currentQuestion.answers
                audioFile = currentQuestion.audioFile
            }
        }
        answerSelected = false
    }
    
    /*
     * 以现有memoRealm中的数据为基础，生成一个随机的问题
     */
    func getRandomExam(answerLength : Int) -> PictureExam.Result?{
        if let memoRealm = realmController.memoRealm,
           let picture = memoRealm.objects(Picture.self).randomElement(){
            let exam = fromPictureGenExam(picture: picture, answerLength: answerLength)
            return exam
        }
        return nil
    }
    
    func goToNextQuestion(){
        switch gameMode {
        case .uniq,.random:
            if index+1 < length{
                // 在random和uniq模式下，做完一题index就多一步
                // finish模式的index增涨是必须答对
                index += 1
                setQuestion()
            }else{
                reachedEnd = true
            }
        case .finish:
            if index < length{
                setQuestion()
            }else{
                reachedEnd = true
            }
        }
    }
    
    func selectAnswer(answer: Answer){
        answerSelected = true
        if answer.isCorrect {
            score += 1
            if gameMode == .finish{
                // 如果是finish模式，把答对的word从memoRealm中清除
                deleteMemoRealmWord(word: question, pictureFileName: answer.name)
                index += 1
            }
        }
    }
    
    /*
     * 生成独一无二的一道Exam，注意，在执行前务必调用
     * genExamRealm 生成题目源
     */
    func getUniqExam(answerLength : Int) -> PictureExam.Result?{
        //        if let memoRealm = realmController.memoRealm {
        //            if let pictureFile = memoRealm.objects(Picture.self).randomElement(),
        //               let exam = fromLocalPictureFileGenExam(pictureFile: pictureFile, answerLength: answerLength){
        //                if pictureFile.words.count < 2 {
        //                    try! memoRealm.write{
        //                        memoRealm.delete(pictureFile)
        //                    }
        //                }else{
        //                    try! memoRealm.write{
        //                        if let index = pictureFile.words.firstIndex(of: exam.questionWord){
        //                            pictureFile.words.remove(at: index)
        //                        }
        //                    }
        //                }
        //                return exam
        //            }
        //        }
        return nil
    }
    
    /*
     * 将pictureFileName的words中的word清除，如果只有唯一的一个word了，将对应的pictureFile清除
     * 用于答对题目时，将已经对的单词从要记忆的单词库中去除
     */
    private func deleteMemoRealmWord(word: String,pictureFileName: String) {
        if let memoRealm = realmController.memoRealm {
            let pictureFiles = memoRealm.objects(Picture.self).where{
                $0.name == pictureFileName && $0.words.name == word
            }
            if let pictureFile = pictureFiles.first{
                do{
                    try memoRealm.write{
                        if pictureFile.words.count == 1{
                            memoRealm.delete(pictureFile.words[0])
                            memoRealm.delete(pictureFile)
                        }else{
                            for w in pictureFile.words{
                                if w.name == word{
                                    memoRealm.delete(w)
                                }
                            }
                        }
                    }
                } catch {
                    Logger().error("Error deleting word \(pictureFileName)/\(word) from Realm: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /*
     * 使用一条LocalPicturefile从localRealm中生成一个PictureExam.Result
     */
    private func fromPictureGenExam(picture: Picture ,answerLength : Int) -> PictureExam.Result?{
        if let localRealm = realmController.localRealm {
            if let topicName = picture.assignee.first?.name {
                if let topic = localRealm.objects(Topic.self).where({$0.name == topicName}).first{
                    var pictures = Array(topic.pictures.where({$0.name != picture.name}).shuffled().prefix(answerLength-1))
                    pictures.append(picture)
                    pictures.shuffle()
                    
                    if let questionWord = picture.words.shuffled().first,
                       let correctAnswer = pictures.firstIndex(of: picture),
                       let topic = picture.assignee.first,
                       let chapter = topic.assignee.first{
                        
                        return PictureExam.Result(
                            questionWord: questionWord.name,
                            correctAnswer: correctAnswer,
                            answers: PicturesToAnswerss(pictures: pictures,correctAnswer:correctAnswer),
                            topic: topic.name,
                            chapter: chapter.name,
                            audioFile: questionWord.audioUrl)
                    }
                }
            }
        }
        return nil
    }
    
    private func PicturesToAnswerss(pictures: [Picture],correctAnswer: Int)-> [Answer]{
        var answers = [Answer]()
        for i in 0...pictures.count-1 {
            answers.append(
                Answer(
                    name: pictures[i].name,
                    isCorrect: i==correctAnswer ? true : false,
                    picUrl: pictures[i].pictureUrl,
                    filePath: pictures[i].filePath
                )
            )
        }
        return answers
    }
}

enum GameMode: String, CaseIterable {
    case uniq = "Uniq"
    case random = "Random"
    case finish = "Finish"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
