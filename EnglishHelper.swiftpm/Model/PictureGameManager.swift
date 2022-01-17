//
//  File.swift
//  
//
//  Created by 老房东 on 2022-01-14.
//

import Foundation
import UIKit

class PictureManager: ObservableObject{
    private var pictures :[Picture] = []
    private var pictureExam : [PictureExam.Result] = []
    private var loadExtDict : Bool = false
    private let localDict = LocalDictFileManager.instance
    private var useLocalDict = false
    
    @Published private(set) var question : String = ""
    @Published private(set) var picture : UIImage?
    @Published private(set) var answerChoices: [Answer] = []
    
    @Published private(set) var reachedEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var index = 0
    @Published private(set) var score = 0

    @Published var length = 10
    @Published var answersLength = 5
    
    init(){
        if localDict.localDicts.contains("picwords"){
            guard
                let json = localDict.getDictJson("picwords"),
                let p : [Picture] = loadByURL(json) else {
                pictures = load("picwords.json")
                generatePictures()
                return
            }
            pictures = p
            useLocalDict = true
        }else{
            pictures = load("picwords.json")
        }
        generatePictures()
    }
    
    func generatePictures(){
        var rs : [PictureExam.Result] = []
        
        for _ in 0..<length{
            if let p = pictures.randomElement() {
                let sfWords = p.words.shuffled()
                var words = [sfWords[0]]
                var indexs = [sfWords[0].index]
                for i in 1..<sfWords.count{
                    if !indexs.contains(sfWords[i].index){
                        words.append(sfWords[i])
                        indexs.append(sfWords[i].index)
                    }
                }
                let ws = Array(words.prefix(answersLength)).sorted(by: {$0.indexHex < $1.indexHex})
                let ca = Int.random(in: 0..<ws.count)
                let w = ws[ca]
                let r = PictureExam.Result(
                    questionPicture: p.name,
                    questionWord: w.name,
                    correctAnswer: ca,
                    answers: ws)
                rs.append(r)
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
            if useLocalDict {
                let path = localDict.getDictPicturePath("picwords", currentQuestion.questionPicture)
                if path == nil{
                    picture = UIImage(contentsOfFile: "AppIcon")
                }else{
                    picture = UIImage(contentsOfFile: path!)
                }
            }else{
                picture = UIImage(named: currentQuestion.questionPicture)!
            }
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
