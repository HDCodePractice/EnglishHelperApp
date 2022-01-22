//
//  PictureGameViewModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation

@MainActor
class PictureGameViewModel: ObservableObject{
    private var manager = PictureGameManager.instance
    private var pictureExam : [PictureExam.Result] = []
    private let answerLength = 4
    
    @Published var loadFinished : Bool = false
    @Published var question : String = ""
    @Published var answerChoices: [Answer] = []
    
    @Published var reachedEnd = false
    @Published var answerSelected = false
    @Published var index = 0
    @Published var score = 0
    
    @Published var length = 10
    
    init(){}
    
    func loadData() async{
        manager.chapters = await manager.loadData()
        if manager.chapters.count == 0{
            loadFinished = false
        }else{
            loadFinished = true
        }
        generatePictureExam()
    }
    
    func generatePictureExam(){
        var rs : [PictureExam.Result] = []
        
        for _ in 0..<length{
            if let chapter = manager.chapters.randomElement() {
                if let topic = chapter.topics.randomElement() {
                    let pics = Array(topic.pictureFiles.shuffled().prefix(answerLength))
                    let answer = Int.random(in: 0..<answerLength)
                    rs.append(PictureExam.Result(
                        questionWord: pics[answer].words.shuffled()[0],
                        correctAnswer: answer,
                        answers: pics,
                        topic: topic,
                        chapter: chapter)
                    )
                }
            }
        }
        pictureExam = rs
        reachedEnd = false
        index = 0
        score = 0
        
        setQuestion()
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
}
