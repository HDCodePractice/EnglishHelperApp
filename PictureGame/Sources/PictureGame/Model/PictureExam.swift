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
        var picture : String
        var topic : String
        var chapter : String
        var audioFile: String
        var isNew: Bool
        var isFavorited: Bool
    }
}
