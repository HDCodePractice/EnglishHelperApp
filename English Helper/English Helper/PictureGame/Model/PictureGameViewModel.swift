//
//  PictureGameViewModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation

@MainActor
class PictureGameViewModel: ObservableObject{
    private var manager = PictureDictionaryManager.instance
    private var realmManager = RealmManager.instance
    private var chapters = [LocalChapter]()
    private var pictureExam : [PictureExam.Result] = []
    private let answerLength = 6
    
    @Published private(set) var loadFinished : Bool = false
    @Published private(set) var question : String = ""
    @Published private(set) var answerChoices: [Answer] = []
    @Published private(set) var reachedEnd = false
    
    @Published var answerSelected = false
    @Published private(set) var index = 0
    @Published private(set) var score = 0
    
    @Published var length = 10
    @Published var startExam = false
    
    init(){}
    
    func loadData() async{
        await manager.fromServerJsonToRealm()
        chapters = realmManager.getAllChapters()

        if manager.chapters.count == 0{
            loadFinished = false
        }else{
            loadFinished = true
        }
    }
    
    func generatePictureExam(){
        var rs : [PictureExam.Result] = []
        
        for _ in 0..<length{
            let cs = chapters.filter{return $0.isSelect}
            if let chapter = cs.randomElement() {
                let topics = chapter.topics.filter{return $0.isSelect}
                if let topic = topics.randomElement() {
                    let pics = Array(topic.pictureFiles.shuffled().prefix(answerLength))
                    let answer = Int.random(in: 0..<answerLength)
                    rs.append(PictureExam.Result(
                        questionWord: pics[answer].words.shuffled().first ?? "\(pics.description)/\(answer)",
                        correctAnswer: answer,
                        answers: pics,
                        topic: topic,
                        chapter: chapter)
                    )
                }
            }
        }
        if rs.count == length{
            pictureExam = rs
            reachedEnd = false
            index = 0
            score = 0
            
            setQuestion()
            startExam = true
        }else{
            startExam = false
        }
    }
    
    func goToNextQuestion(){
        if index + 1 < length{
            index += 1
            setQuestion()
        }else{
            reachedEnd = true
        }
    }
    
    func setQuestion(){
        if index < length{
            if pictureExam.count == 0 { return }
            let currentQuestion = pictureExam[index]
            question = currentQuestion.questionWord
            answerChoices = currentQuestion.questAnswers
        }
        answerSelected = false
    }
    
    func selectAnswer(answer: Answer){
        answerSelected = true
        if answer.isCorrect {
            score += 1
        }
    }
    
    func mokeData(){
        if let d: [Chapter] = load("example_picture.json"){
            manager.chapters = d
        }else{
            manager.chapters = []
        }
        chapters = realmManager.getAllChapters()
        loadFinished = true
        generatePictureExam()
        reachedEnd = true
    }
    
    func toggleChapter(name: String){
        if let cindex = chapters.firstIndex(where: {$0.name == name}){
            chapters[cindex].isSelect.toggle()
            
            if chapters[cindex].isSelect {
                for tindex in 0..<chapters[cindex].topics.count {
                    chapters[cindex].topics[tindex].isSelect = true
                }
            }else{
                for tindex in 0..<chapters[cindex].topics.count {
                    chapters[cindex].topics[tindex].isSelect = false
                }
            }
        }
    }
    
    func toggleTopic(name: String,chaptername: String){
        if let cindex = chapters.firstIndex(where: {$0.name == chaptername}){
            if let tindex = chapters[cindex].topics.firstIndex(where: {$0.name == name}){
                chapters[cindex].topics[tindex].isSelect.toggle()
                // 如果chapter没选，顺便选上
                if chapters[cindex].topics[tindex].isSelect && !chapters[cindex].isSelect{
                    chapters[cindex].isSelect = true
                    return
                }
                
                // 如果chapter选上了，查看是不是所有的都是没选中的，如果都没选，chapter也取消选择
                if chapters[cindex].isSelect{
                    for t in chapters[cindex].topics{
                        if t.isSelect{
                            return
                        }
                    }
                    // 所有子项都没选择，把chapter也取消选择
                    chapters[cindex].isSelect = false
                }
            }
        }
    }
}
