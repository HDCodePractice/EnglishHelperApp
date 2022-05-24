//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation
import RealmSwift
import OSLog

public class Picture: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var words = RealmSwift.List<Word>()
    @Persisted(originProperty: "pictures") public var assignee: LinkingObjects<Topic>
}

public extension Picture{
    func delete(){
        if let thawed=self.thaw(), let localRealm = thawed.realm{
            do{
                for word in self.words{
                    word.delete()
                }
                try localRealm.write{
                    localRealm.delete(self)
                }
            } catch {
                Logger().error("Error deleting pictureFiles \(self) from Realm: \(error.localizedDescription)")
            }
        }
    }
    
}

public extension Picture{
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
    
    var pictureUrl:String{
        return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/\(filePath)".urlEncoded()
    }
}

struct JPictureFile: Codable {
    var name: String
    var words = [String]()
}
