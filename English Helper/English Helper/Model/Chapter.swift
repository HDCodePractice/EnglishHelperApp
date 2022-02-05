//
//  Chapter.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation
import RealmSwift

struct Chapter: Codable,Identifiable {
    var id = UUID()
    var name: String
    var topics = [Topic]()
    var isSelect = true
    enum CodingKeys: String, CodingKey {
        case topics
        case name
    }
}

class LocalChapter: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var isSelect = true
    @Persisted var topics = RealmSwift.List<LocalTopic>()
}
