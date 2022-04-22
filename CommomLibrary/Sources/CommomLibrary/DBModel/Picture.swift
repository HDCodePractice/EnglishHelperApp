//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation
import RealmSwift

public class Picture: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var name: String
    @Persisted public var words = RealmSwift.List<Word>()
    @Persisted(originProperty: "pictures") public var assignee: LinkingObjects<Topic>
}

extension Picture{
    var filePath:String{
        if let topic=self.assignee.first,
           let chapter = topic.assignee.first{
            let chapterName = chapter.name
            let topicName = topic.name
            let fileName = self.name
            return "\(chapterName)/\(topicName)/\(fileName)"
        }
        return ""
    }
    
    var audioUrl:String{
        return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/audio/\(filePath).wav"
    }
    
    var pictureUrl:String{
        return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/\(filePath).jpg"
    }
}

struct JPictureFile: Codable {
    var name: String
    var words = [String]()
}
