//
//  File.swift
//  
//
//  Created by 老房东 on 2022-01-06.
//

import Foundation

struct PictureExam{
    var results: [Result]
    
    struct Result: Identifiable{
        var id:UUID{
            UUID()
        }
        var questionPicture: String
        var questionWord: String
        var correctAnswer: Int
        var answers : [PictureWord]
        
        var questAnswers: [Answer]{
            var _answers : [Answer] = []
            for i in 0..<answers.count {
                _answers.append(Answer(name: answers[i].index, isCorrect: i==correctAnswer ? true : false))
            }
            return _answers
        }
    }
}
