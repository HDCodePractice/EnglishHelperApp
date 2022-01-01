//
//  File.swift
//  
//
//  Created by 老房东 on 2021-12-31.
//

import Foundation

struct ImageExam{
    var results: [Result]
    
    struct Result: Identifiable{
        var id:UUID{
            UUID()
        }
        var question:String
        var correctAnswer: Int
        var answers : [String]
        var formattedQuestion: String{
//            let nameArrar = question.components(separatedBy: ".")
//            return nameArrar[0]
            return question
        }
        
        var questAnswers: [Answer]{
            var _answers : [Answer] = []
            for i in 0..<answers.count {
                _answers.append(Answer(name: answers[i], isCorrect: i==correctAnswer ? true : false))
            }
            return _answers
        }
    }
}

