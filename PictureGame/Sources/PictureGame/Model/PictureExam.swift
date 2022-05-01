//
//  PictureExam.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-22.
//

import Foundation
import CommomLibrary

struct PictureExam{
    var results: [Result]
    
    struct Result: Identifiable{
        var id:UUID{
            UUID()
        }
        var questionWord: String
        var correctAnswer: Int
        var answers : [Answer]
        var topic : String
        var chapter : String
        var audioFile: String
        
//        var questAnswers: [Answer]{
//            var _answers : [Answer] = []
//            for i in 0..<answers.count {
//                _answers.append(
//                    Answer(
//                        name: answers[i].name,
//                        isCorrect: i==correctAnswer ? true : false,
//                        picUrl: URL(string: answers[i].pictureUrl)!
//                    )
//                )
//            }
//            return _answers
//        }
        
//        var audioFile: String{
//            return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/audio/\(chapter)/\(topic)/\(questionWord).wav"
//        }
    }
}
