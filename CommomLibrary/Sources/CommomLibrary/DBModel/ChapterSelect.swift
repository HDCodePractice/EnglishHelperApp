//
//  File.swift
//  
//
//  Created by 老房东 on 2022-05-22.
//

import RealmSwift
import IceCream

public class ChapterSelect: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var name: String
    @Persisted public var isSelected = true
    @Persisted public var isDeleted = false
}

extension ChapterSelect: CKRecordConvertible{}
extension ChapterSelect: CKRecordRecoverable{}
