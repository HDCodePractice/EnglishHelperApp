//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation
import RealmSwift

public class Chapter: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted public var name: String
    @Persisted public var isSelect = true
    @Persisted public var topics = RealmSwift.List<Topic>()
}

struct JChapter: Codable,Identifiable {
    public var id = UUID()
    var name: String
    var topics = [JTopic]()
    var isSelect = true
    enum CodingKeys: String, CodingKey {
        case topics
        case name
    }
}
