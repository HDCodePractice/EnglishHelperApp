//
//  Topic.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation
import RealmSwift

struct Topic: Codable, Identifiable {
    var id = UUID()
    var pictureFiles = [PictureFile]()
    var name: String
    var isSelect = true
    enum CodingKeys: String, CodingKey {
        case pictureFiles
        case name
    }
}

class LocalTopic: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var isSelect = true
    @Persisted var pictureFiles = RealmSwift.List<LocalPictureFile>()
    
    @Persisted(originProperty: "topics") var assignee: LinkingObjects<LocalChapter>

}
