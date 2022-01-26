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
    private let answerLength = 6
    
    @Published private(set) var loadFinished : Bool = false
    @Published private(set) var question : String = ""
    @Published private(set) var answerChoices: [Answer] = []
    @Published private(set) var reachedEnd = false
    
    @Published var answerSelected = false
    @Published private(set) var index = 0
    @Published private(set) var score = 0
    
    @Published var length = 10
    @Published private(set) var loadDataProgress = 0.0
    
    init(){}
    
    func loadData() async{
        if let d: [Chapter] = await loadDataByServer(url: manager.jsonURL) {
            manager.chapters = d
        }else{
            manager.chapters = []
        }
        if manager.chapters.count == 0{
            loadFinished = false
        }else{
            loadFinished = true
        }
    }
    
    private func loadDataByServer<T: Decodable>(url: String) async -> T?{
        guard let url = URL(string: url) else { return nil}
        
        do{
            let (asyncBytes,response) = try await URLSession.shared.bytes(from: url)
            let dataLenght = response.expectedContentLength
            var data = Data()
            data.reserveCapacity(Int(dataLenght))
            for try await byte in asyncBytes {
                data.append(byte)
                loadDataProgress = Double(data.count) / Double(dataLenght)
            }
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch let error{
            print("load Data error:\n\(error)")
            return nil
        }
    }
    
    
    func generatePictureExam(){
        var rs : [PictureExam.Result] = []
        
        for _ in 0..<length{
            if let chapter = manager.chapters.randomElement() {
                if let topic = chapter.topics.randomElement() {
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
        question = "Hello World"
        answerChoices = [
            Answer(name: "brackets.jpg", isCorrect: true, chapter: "Computer", topic: "Program"),
            Answer(name: "stomachache.png", isCorrect: false, chapter: "Health", topic: "Symptoms and Injuries"),
            Answer(name: "earache.jpg", isCorrect: false, chapter: "Health", topic: "Symptoms and Injuries"),
            Answer(name: "earache.jpg", isCorrect: false, chapter: "Health", topic: "Symptoms and Injuries"),
            Answer(name: "earache.jpg", isCorrect: false, chapter: "Health", topic: "Symptoms and Injuries"),
            Answer(name: "toothache.jpg", isCorrect: false, chapter: "Health", topic: "Symptoms and Injuries")
        ]
        index = 2
        score = 3
    }
}
