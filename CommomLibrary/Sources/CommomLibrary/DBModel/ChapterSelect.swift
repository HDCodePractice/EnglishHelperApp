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
