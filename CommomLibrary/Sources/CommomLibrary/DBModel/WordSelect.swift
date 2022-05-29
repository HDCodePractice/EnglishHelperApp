//
//  WordSelect.swift
//  
//
//  Created by 老房东 on 2022-05-28.
//

import RealmSwift
import IceCream
import OSLog

public class WordSelect: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var isDeleted = false
    @Persisted public var isFavorited: Bool = false
    @Persisted public var isNew: Bool = true
}

extension WordSelect: CKRecordConvertible{}
extension WordSelect: CKRecordRecoverable{}

extension WordSelect{
    func deleteTransaction(_ localRealm: Realm){
        self.isDeleted = true
    }
    
    static func addNewWordSelectTransaction(
        localRealm: Realm,id:String,name:String,
        isFavorited:Bool=false,isNew:Bool=true){
        let wordSelect = WordSelect(value: [
            "id": id,
            "name": name,
            "isFavorited": isFavorited,
            "isNew": isNew,
            "isDeleted": false
        ])
        localRealm.add(wordSelect,update: .modified)
    }
}
