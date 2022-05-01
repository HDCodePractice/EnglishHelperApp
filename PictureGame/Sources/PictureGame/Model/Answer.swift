//
//  File.swift
//  
//
//  Created by Lei Zhou on 3/6/22.
//

import Foundation

struct Answer: Identifiable {
    var id: UUID = UUID()
    var name : String
    var isSeleted: Bool = false
    var isCorrect: Bool
    var picUrl: String
    var filePath : String
}

//struct Answer: Identifiable{
//    var id = UUID()
//    var name : String
//    var isCorrect : Bool
//    var chapter : String
//    var topic : String
//    var url : URL?{
//        let url = PictureDictionaryManager.genPictureURL(chapter: chapter, topic: topic, filename: name)
//        return url
//    }
//}
