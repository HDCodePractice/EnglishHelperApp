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
    func delete(isAsync:Bool=false,onComplete: ((Swift.Error?) -> Void)? = nil) {
        if let thawed=self.thaw(), let localRealm = thawed.realm{
            if isAsync{
                localRealm.writeAsync{
                    self.deleteTransaction(localRealm)
                } onComplete: { error in
                    if let error=error{
                        Logger().error("Error deleting \(self) from Realm: \(error.localizedDescription)")
                    }
                    if let onComplete = onComplete {
                        onComplete(error)
                    }
                }
            }else{
                do{
                    try localRealm.write{
                        self.deleteTransaction(localRealm)
                    }
                } catch {
                    Logger().error("Error deleting \(self) from Realm: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteTransaction(_ localRealm: Realm){
        for word in self.words{
            word.deleteTransaction(localRealm)
        }
        localRealm.delete(self)
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
