//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation
import RealmSwift
import OSLog
import IceCream

public class Word: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted(indexed: true) public var name: String
    @Persisted public var isNew: Bool = true
    @Persisted public var isFavorited: Bool = false
    @Persisted public var isDeleted = false
    @Persisted(originProperty: "words") public var assignee: LinkingObjects<Picture>
}

extension Word: CKRecordConvertible{}
extension Word: CKRecordRecoverable{}

public extension Word{
    var words : [String]{
        var ws : [String] = []
        if let picture=self.assignee.first{
            for w in picture.words{
                ws.append(w.name)
            }
        }
        return ws
    }
    
    var wordsTitle: String{
        var title=""
        if words.isEmpty{
            return ""
        }
        if words.count == 1{
            return words[0]
        }
        for i in 0..<words.count-1 {
            title += words[i]
            title += " / "
        }
        title += words[words.count-1]
        return title
    }
    
    var chapterName:String{
        if let picture=self.assignee.first,
           let topic=picture.assignee.first,
           let chapter=topic.assignee.first{
            return chapter.name
        }
        return ""
    }
    
    var topicName:String{
        if let picture=self.assignee.first,
           let topic=picture.assignee.first{
            return topic.name
        }
        return ""
    }
    
    var fileName:String{
        if let picture=self.assignee.first{
            return picture.name
        }
        return ""
    }
    
    var filePath:String{
        if let picture=self.assignee.first,
           let topic=picture.assignee.first,
           let chapter=topic.assignee.first{
            let chapterName = chapter.name
            let topicName = topic.name
            let fileName = picture.name
            return "\(chapterName)/\(topicName)/\(fileName)"
        }
        return ""
    }
    
    var audioFilePath:String{
        if let picture=self.assignee.first,
           let topic=picture.assignee.first,
           let chapter=topic.assignee.first{
            let chapterName = chapter.name
            let topicName = topic.name
            let fileName = self.name
            return "\(chapterName)/\(topicName)/\(fileName)"
        }
        return ""
    }
    
    var audioUrl:String{
        return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/audio/\(audioFilePath).wav".urlEncoded()
    }
    
    var pictureUrl:String{
        return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/\(filePath)".urlEncoded()
    }
    
    func toggleFavorite(){
        if let thawWord = self.thaw(){
            if let localRealm = thawWord.realm{
                do{
                    try localRealm.write{
                        thawWord.isFavorited.toggle()
                    }
                } catch {
                    Logger().error("Error toggle isFavorite \(self) from Realm: \(error.localizedDescription)")
                }
            }
        }
    }
}
