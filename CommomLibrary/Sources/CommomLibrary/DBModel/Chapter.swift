//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import RealmSwift
import OSLog

public class Chapter: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var name: String
    @Persisted public var topics = RealmSwift.List<Topic>()
}

extension Chapter{
    var isSelected: Bool{
        if let localRealm = self.realm{
            let count = localRealm.objects(ChapterSelect.self).where {
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
        for topic in self.topics{
            topic.deleteTransaction(localRealm)
        }
        let chapterSelects = localRealm.objects(ChapterSelect.self).where {
            $0.name==self.name
        }
        if let chapterSelect=chapterSelects.first{
            chapterSelect.isDeleted = true
        }
        localRealm.delete(self)
    }
    
    func toggleSelect(isChangeTopics:Bool=false){
        if let thawed=self.thaw(), let localRealm = thawed.realm {
            do{
                try localRealm.write{
                    let setSelect = !self.isSelected
                    self.setChapterSelectTransaction(localRealm: localRealm, isSelected: setSelect, isChangeTopics: true)
                }
            }catch{
                Logger().error("setChapterSelect \(self.name) error: \(error.localizedDescription)")
            }
        }
    }
    
    func setChapterSelect(isSelected:Bool,isChangeTopics:Bool=false){
        if let thawed=self.thaw(), let localRealm = thawed.realm {
            do{
                try localRealm.write{
                    self.setChapterSelectTransaction(localRealm: localRealm, isSelected: isSelected, isChangeTopics: isChangeTopics)
                }
            }catch{
                Logger().error("setChapterSelect \(self.name) error: \(error.localizedDescription)")
            }
        }
    }
 
    /// 设置chapter的选择状态的数据库Transaction操作，可以将多个Transaction放入一个write保持数据库的事务
    /// - Parameters:
    ///   - localRealm: 进行操作的Realm实例，应该已经初始化好进入write状态
    ///   - isSelected: 将选择设置为的状态
    ///   - isChangeTopics: 是否同步设置所属topic选择状态
    func setChapterSelectTransaction(localRealm:Realm, isSelected:Bool, isChangeTopics:Bool){
        ChapterSelect.addNewChapterSelectTransaction(
            localRealm: localRealm,
            name: self.name,
            isSelected: isSelected
        )
        if isChangeTopics{
            for topic in self.topics{
                if topic.isSelect != isSelected, let topic=topic.thaw(){
                    topic.isSelect = isSelected
                }
            }
        }
    }
}

public struct JChapter: Codable {
    var name: String
    var topics = [JTopic]()
    var isSelect = true
    enum CodingKeys: String, CodingKey {
        case topics
        case name
    }
}
