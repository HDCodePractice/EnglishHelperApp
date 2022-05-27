//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation
import RealmSwift
import OSLog

public class Topic: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var name: String
    @Persisted public var isSelect = true
    @Persisted public var pictures = RealmSwift.List<Picture>()
    
    @Persisted(originProperty: "topics") public var assignee: LinkingObjects<Chapter>
}

public extension Topic{
    var isSelected: Bool{
        if let localRealm = self.realm{
            let count = localRealm.objects(TopicSelect.self).where {
                $0.name==self.name && $0.isSelected==false
            }.count
            if count>0{
                return false
            }
        }
        return true
    }
    
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
        for picture in self.pictures{
            picture.deleteTransaction(localRealm)
        }
        localRealm.delete(self)
    }
    
    
    /// 设置Topic的选择状态的数据库Transaction操作，可以将多个Transaction放入一个write保持数据库的事务
    /// - Parameters:
    ///   - localRealm: 进行操作的Realm实例，应该已经初始化好进入write状态
    ///   - isSelected: 将选择设置为的状态
    ///   - isChangeChapter: 是否同步设置topic所属的chapter的选择状态
    func setTopicSelectTransaction(localRealm:Realm, isSelected:Bool, isChangeChapter:Bool){
        TopicSelect.addNewTopicSelectTransaction(
            localRealm: localRealm,
            name: self.name,
            isSelected: isSelected
        )
    }
}

struct JTopic: Codable {
    var name: String
    var pictureFiles = [JPictureFile]()
    var isSelect = true
    enum CodingKeys: String, CodingKey {
        case pictureFiles
        case name
    }
}
