//
//  PictureFile.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation
import RealmSwift

struct PictureFile: Codable {
    var name: String
    var words = [String]()
}


class LocalPictureFile: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var words = List<String>()
    @Persisted(originProperty: "pictureFiles") var assignee: LinkingObjects<LocalTopic>
    
    func toPictureFile() -> PictureFile{
        var ws = [String]()
        for word in words{
            ws.append(word)
        }
        return PictureFile(name: name, words: ws)
    }
}
