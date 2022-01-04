//
//  File.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021/12/18.
//
import Combine
import Foundation
import SwiftUI

//public final class ModelData:ObservableObject{
//    @Published var grammars: [Grammar] = load("grammar.json")
//    public init(){}
//}

var grammars: [Grammar] = load("grammar.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


class ImageExamManager: ObservableObject{
    private var imageExam : [ImageExam.Result] = []
    @Published private(set) var length = 0
    @Published private(set) var index = 0
    @Published private(set) var reachedEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question = ""
    @Published private(set) var answerChoices: [Answer] = []
    @Published private(set) var score = 0

    init(){
        fetchImageExam()
    }

    func fetchImageExam(){
        var words = [
            "sun.max","sunrise","sunset","moon","cloud","sun.dust","moon.stars",
            "cloud.drizzle","cloud.rain","cloud.heavyrain","cloud.fog",
            "cloud.hail","cloud.snow","cloud.sun","wind","snowflake",
            "tornado","thermometer","hurricane","humidity","paperclip",
            "flame","hare","ladybug","leaf","paperplane","graduationcap",
            "umbrella","megaphone","bell","eyeglasses","facemask","camera",
            "gear","scissors","speedometer","amplifier","dice","pianokeys",
            "tuningfork","paintbrush","bandage","wrench","hammer","screwdriver",
            "eyedropper","stethoscope","briefcase","theatermasks","puzzlepiece",
            "powerplug","guitars","fuelpump","fanblades","crown","comb",
            "hourglass","binoculars","lightbulb","heart","lungs","tram",
            "cablecar","ferry","bicycle"
        ]
        var correctAnswer = Int.random(in: 0...2)
        var rs : [ImageExam.Result] = []
        
        for _ in 0...9 {
            words = words.shuffled()
            correctAnswer = Int.random(in: 0...2)
            let r = ImageExam.Result(
                question: words[correctAnswer],
                correctAnswer: correctAnswer,
                answers: [words[0],words[1],words[2]])
            rs.append(r)
        }
        self.imageExam = rs
        self.length = rs.count
        
        self.index = 0
        self.score = 0
        self.reachedEnd = false
        
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
        answerSelected = false
        
        if index < length{
            let currentQuestion = imageExam[index]
            question = currentQuestion.formattedQuestion
            answerSelected = false
            answerChoices = currentQuestion.questAnswers
        }
    }
    
    func selectAnswer(answer: Answer){
        answerSelected = true
        if answer.isCorrect {
            score += 1
        }
    }
}
