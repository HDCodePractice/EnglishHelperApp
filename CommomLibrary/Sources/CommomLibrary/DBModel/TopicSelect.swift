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
    
    static func addNewTopicSelectTransaction(localRealm: Realm,name:String,isSelected:Bool){
        let topicSelect = TopicSelect(value: [
            "name": name,
            "isSelected": isSelected,
            "isDeleted": false
        ])
        localRealm.add(topicSelect,update: .modified)
    }
}
