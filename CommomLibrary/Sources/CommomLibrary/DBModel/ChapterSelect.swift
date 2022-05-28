//
//  File.swift
//  
//
//  Created by 老房东 on 2022-05-22.
//

import RealmSwift
import IceCream
import OSLog

public class ChapterSelect: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var name: String
    @Persisted public var isSelected = true
    @Persisted public var isDeleted = false
}

extension ChapterSelect: CKRecordConvertible{}
extension ChapterSelect: CKRecordRecoverable{}

extension ChapterSelect{
    func deleteTransaction(_ localRealm: Realm){
        self.isDeleted = true
    }
    
    static func addNewChapterSelectTransaction(localRealm: Realm,name:String,isSelected:Bool){
        let chapterSelect = ChapterSelect(value: [
            "name": name,
            "isSelected": isSelected,
            "isDeleted": false
        ])
        localRealm.add(chapterSelect,update: .modified)
    }
}
