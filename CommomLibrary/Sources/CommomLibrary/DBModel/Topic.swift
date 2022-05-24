//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation
import RealmSwift
import OSLog

public class Topic: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var name: String
    @Persisted public var isSelect = true
    @Persisted public var pictures = RealmSwift.List<Picture>()
    
    @Persisted(originProperty: "topics") public var assignee: LinkingObjects<Chapter>
}

public extension Topic{
    func delete() {
        if let thawed=self.thaw(), let localRealm = thawed.realm{
            do{
                for picture in self.pictures{
                    picture.delete()
                }
                try localRealm.write{
                    localRealm.delete(self)
                }
            } catch {
                Logger().error("Error deleting topic \(self) from Realm: \(error.localizedDescription)")
            }
        }
    }
}

struct JTopic: Codable {
    var name: String
    var pictureFiles = [JPictureFile]()
    var isSelect = true
    enum CodingKeys: String, CodingKey {
        case pictureFiles
        case name
    }
}
