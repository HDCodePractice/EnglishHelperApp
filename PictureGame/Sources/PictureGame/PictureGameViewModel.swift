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
    @Published var gameMode = GameMode.topics
    @Published var length = 10
    
    @Published private(set) var index = 0
    @Published private(set) var answerCount = 0
    
    @Published var answerSelected = false
    @Published var isShowOne = false
    
    @Published private(set) var question : String = ""
    @Published private(set) var answerChoices: [Answer] = []
    @Published private(set) var audioFile : String = ""
    @Published private(set) var correctAnswer: Int = 0
    
    @Published private(set) var currentQuestion : PictureExam.Result?
    
    var realmPath:String{
        if let localRealm = realmController.localRealm,
           let fileURL = localRealm.configuration.fileURL{
            return fileURL.path
        }
        return "NoPath"
    }
    
    init(isPreview:Bool=false){
        if isPreview{
            realmController = RealmController.preview
        }else{
            realmController = RealmController.shared
        }
        setGameMode(mode: .topics)
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
    
    /// 设置游戏模式，为了更新这个模式下的可用词汇量
    /// - Parameter mode: 模式
    func setGameMode(mode: GameMode){
        self.gameMode = mode
        guard let localRealm = realmController.localRealm else{
            return
        }
        
        let wordsNumber = localRealm.objects(Word.self).where { word in
            let filter : Query<Bool>
            switch gameMode {
            case .topics:
                filter = Topic.isSelectedFilter(localRealm: localRealm, assignee: word.assignee.assignee)
            case .new:
                filter = Word.isNewFilter(localRealm: localRealm, word: word)
            case .favorite:
                filter = Word.isFavoritedFilter(localRealm: localRealm,isFavorited: true, word: word)
            }
            return filter
        }.count
        length = wordsNumber
    }
    
    /**
     生成出题的题库
     **/
    func generatePictureExam(){
        guard let localRealm = realmController.localRealm , let memoRealm = realmController.memoRealm else{
            return
        }
        
        // 将包括目标内容的chapters过滤出来
        let chapters = localRealm.objects(Chapter.self).where{ chapter in
            let filter : Query<Bool>
            switch gameMode {
            case .topics:
                filter = Chapter.isSelectedFilter(localRealm: localRealm, chapter: chapter)
            case .new:
//                filter = Word.isNewFilter(localRealm: localRealm, isNew: true, words: chapter.topics.pictures.words)
                filter = chapter.name==chapter.name
            case .favorite:
                filter=Word.isFavoritedFilter(localRealm: localRealm, isFavorited: true, words: chapter.topics.pictures.words)
            }
            return filter
        }
        
        try! memoRealm.write{
            memoRealm.deleteAll()
            // 将内容复制到内存中
            for chapter in chapters{
                memoRealm.create(Chapter.self, value: chapter)
            }
            
            let noSelectWords = memoRealm.objects(Word.self).where { word in
                let filter : Query<Bool>
                switch gameMode {
                case .topics:
                    filter = Topic.isSelectedFilter(localRealm: localRealm,isSelected: false, assignee: word.assignee.assignee)
                case .new:
                    filter = Word.isNewFilter(localRealm: localRealm, isNew: false, word: word)
                case .favorite:
                    filter = Word.isFavoritedFilter(localRealm: localRealm, isFavorited: false, word: word)
                }
                return filter
            }
            memoRealm.delete(noSelectWords)
            
            let noSelectPictureFiles = memoRealm.objects(Picture.self).where{
                let filter : Query<Bool>
                switch gameMode {
                case .topics:
                    filter = Topic.isSelectedFilter(localRealm: localRealm, isSelected: false, assignee: $0.assignee)
                case .new,.favorite:
                    filter = $0.words.count==0
                }
                return filter
            }
            memoRealm.delete(noSelectPictureFiles)
            
            let noSelectTopics = memoRealm.objects(Topic.self).where{
                let filter : Query<Bool>
                switch gameMode {
                case .topics:
                    filter = Topic.isSelectedFilter(localRealm: localRealm, isSelected: false, topic: $0)
                case .new,.favorite:
                    filter = $0.pictures.count==0
                }
                return filter
            }
            memoRealm.delete(noSelectTopics)
        }
        
        length = memoRealm.objects(Word.self).count
        
        if length == 0 {
            return
        }
        index = 0
        answerCount = 0
        
        setQuestion()
        gameStatus = .inProgress
    }
    
    func setQuestion(){
        if index < length{
            currentQuestion = getRandomExam(answerLength: answerLength)
            if let currentQuestion = currentQuestion {
                question = currentQuestion.questionWord
                answerChoices = currentQuestion.answers
                audioFile = currentQuestion.audioFile
                correctAnswer = currentQuestion.correctAnswer
            }
        }
        answerSelected = false
        isShowOne = false
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
        if index < length{
            setQuestion()
        }else{
            gameStatus = .finish
        }
    }
    
    func selectAnswer(answer: Answer){
        answerSelected = true
        // 找到点击的answer
        if let selectIndex = answerChoices.firstIndex(where: {$0.id==answer.id}){
            answerChoices[selectIndex].isSelected = true
            if correctAnswer != selectIndex{
                answerChoices[correctAnswer].isSelected = true
            }
        }
        
        if answer.isCorrect {
            // 把答对的word从memoRealm中清除
            deleteMemoRealmWord(word: question, pictureFileName: answer.name)
            // 设置对currentQuestion的isNew为false
            if currentQuestion?.isNew ?? false{
                setWordToNotNew()
            }
            index += 1
        }
        answerCount += 1
    }
    
    private func setWordToNotNew(){
        if let localRealm = realmController.localRealm,let currentQuestion=currentQuestion{
            if let w = localRealm.object(ofType: Word.self, forPrimaryKey: currentQuestion.id){
                do{
                    try localRealm.write{
                        w.setIsNewTransaction(localRealm: localRealm, isNew: false)
                    }
                }catch{
                    Logger().error("Error set word \(currentQuestion.questionWord) to not new from Realm:\(error.localizedDescription)")
                }
            }
        }
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
    private func fromPictureGenExam(picture: CommomLibrary.Picture ,answerLength : Int) -> PictureExam.Result?{
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
                            id: questionWord.id,
                            questionWord: questionWord.name,
                            correctAnswer: correctAnswer,
                            answers: PicturesToAnswerss(pictures: pictures,correctAnswer:correctAnswer),
                            picture: picture.name,
                            topic: topic.name,
                            chapter: chapter.name,
                            audioFile: questionWord.audioUrl,
                            isNew: questionWord.isNew,
                            isFavorited: questionWord.isFavorited
                        )
                    }
                }
            }
        }
        return nil
    }
    
    private func PicturesToAnswerss(pictures: [CommomLibrary.Picture],correctAnswer: Int)-> [Answer]{
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
    case new = "News"
    case favorite = "Favorites"
    case topics = "Topics"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
