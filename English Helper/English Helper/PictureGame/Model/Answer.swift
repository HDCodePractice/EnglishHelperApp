//
//  Answer.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import Foundation

struct Answer: Identifiable{
    var id = UUID()
    var name : String
    var isCorrect : Bool
    var chapter : String
    var topic : String
    var url : URL?{
        let url = PictureGameManager.genPictureURL(chapter: chapter, topic: topic, filename: name)
        return url
    }
}
