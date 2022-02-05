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
        var topic : LocalTopic
        var chapter : LocalChapter
        
        var questAnswers: [Answer]{
            var _answers : [Answer] = []
            for i in 0..<answers.count {
                _answers.append(
                    Answer(
                        name: answers[i].name,
                        isCorrect: i==correctAnswer ? true : false,
                        chapter: chapter.name,
                        topic: topic.name
                    )
                )
            }
            return _answers
        }
    }
}
