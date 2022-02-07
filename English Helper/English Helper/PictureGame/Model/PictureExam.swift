//
//  PictureExam.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-22.
//

import Foundation

struct PictureExam{
    var results: [Result]
    
    struct Result: Identifiable{
        var id:UUID{
            UUID()
        }
        var questionWord: String
        var correctAnswer: Int
        var answers : [LocalPictureFile]
        var topic : String
        var chapter : String
        
        var questAnswers: [Answer]{
            var _answers : [Answer] = []
            for i in 0..<answers.count {
                _answers.append(
                    Answer(
                        name: answers[i].name,
                        isCorrect: i==correctAnswer ? true : false,
                        chapter: chapter,
                        topic: topic
                    )
                )
            }
            return _answers
        }
    }
}
