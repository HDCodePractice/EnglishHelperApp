//
//  TopicSelect.swift
//  
//
//  Created by 老房东 on 2022-05-26.
//

import RealmSwift
import IceCream
import OSLog

public class TopicSelect: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var name: String
    @Persisted public var isSelected = true
    @Persisted public var isDeleted = false
}

extension TopicSelect: CKRecordConvertible{}
extension TopicSelect: CKRecordRecoverable{}

extension TopicSelect{
    func deleteTransaction(_ localRealm: Realm){
        self.isDeleted = true
    }
    
    static func addNewTopicSelectTransaction(localRealm: Realm,name:String,isSelected:Bool){
        let topicSelect = TopicSelect(value: [
            "name": name,
            "isSelected": isSelected,
            "isDeleted": false
        ])
        localRealm.add(topicSelect,update: .modified)
    }
}
