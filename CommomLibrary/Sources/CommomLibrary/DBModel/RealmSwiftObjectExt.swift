//
//  File.swift
//  
//
//  Created by 老房东 on 2022-05-26.
//

//import RealmSwift
//import OSLog
//
//protocol Deleteable {
//    func delete(isAsync:Bool,onComplete: ((Swift.Error?) -> Void)?)
//
//    func deleteTransaction(_ localRealm: Realm)
//}
//
//extension Object: Deleteable{
//    func deleteTransaction(_ localRealm: Realm) {
//        return
//    }
//
//    func delete(isAsync:Bool=false,onComplete: ((Swift.Error?) -> Void)? = nil) {
//        if let thawed=self.thaw(), let localRealm = thawed.realm{
//            if isAsync{
//                localRealm.writeAsync{
//                    self.deleteTransaction(localRealm)
//                } onComplete: { error in
//                    if let error=error{
//                        Logger().error("Error deleting \(self) from Realm: \(error.localizedDescription)")
//                    }
//                    if let onComplete = onComplete {
//                        onComplete(error)
//                    }
//                }
//            }else{
//                do{
//                    try localRealm.write{
//                        self.deleteTransaction(localRealm)
//                    }
//                } catch {
//                    Logger().error("Error deleting \(self) from Realm: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
