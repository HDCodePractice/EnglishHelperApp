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
        if let topicSelect = localRealm.objects(TopicSelect.self).where({
            $0.name==self.name
        }).first{
            topicSelect.isDeleted=true
        }
        localRealm.delete(self)
    }
    
    func toggleSelect(isChangeChapter:Bool=false){
        if let thawed=self.thaw(), let localRealm = thawed.realm {
            do{
                try localRealm.write{
                    let setSelect = !self.isSelected
                    self.setTopicSelectTransaction(
                        localRealm: localRealm,
                        isSelected: setSelect,
                        isChangeChapter: true
                    )
                }
            }catch{
                Logger().error("setTopicSelect \(self.name) error: \(error.localizedDescription)")
            }
        }
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
        if isChangeChapter{
            if let chapter = self.assignee.first{
                // 如果chapter没选，顺便选上
                if isSelected && !chapter.isSelected{
                    chapter.setChapterSelectTransaction(
                        localRealm: localRealm,
                        isSelected: true,
                        isChangeTopics: false
                    )
                    return
                }
                // 如果chapter选上了，查看是不是所有的都是没选中的，如果都没选，chapter也取消选择
                if chapter.isSelected{
                    for t in chapter.topics{
                        let count = localRealm.objects(TopicSelect.self).where {
                            $0.name==t.name && $0.isSelected==false
                        }.count
                        if count==0{
                            return
                        }
                    }
                    // 有子项都没选择，把chapter也取消选择
                    chapter.setChapterSelectTransaction(
                        localRealm: localRealm,
                        isSelected: false,
                        isChangeTopics: false
                    )
                }
            }
        }
    }
    
    /// 生成被选择的Topic查询表达式
    /// - Parameters:
    ///   - localRealm: 可用的Realm实例
    ///   - topic: 执行where查询的topic实例
    /// - Returns: 查询表达式
    static func isSelectedFilter(localRealm:Realm, isSelected:Bool=true,topic: Query<Topic>?=nil, assignee: Query<LinkingObjects<Topic>>?=nil) -> Query<Bool> {
        // 准备好subquery
        let topicSelects = localRealm.objects(TopicSelect.self)
        // 找出所有没被选中的chapters
        var isNotSelecteds: [String] = topicSelects.where { select in
            select.isSelected==false && select.isDeleted==false
        }.map{ $0.name }
        if isNotSelecteds.count==0{
            isNotSelecteds = [""]
        }
        if let topic = topic {            
            if isSelected {
                return !topic.name.in(isNotSelecteds)
            }else{
                return topic.name.in(isNotSelecteds)
            }
        }
        if isSelected {
            return !assignee!.name.in(isNotSelecteds)
        }else{
            return assignee!.name.in(isNotSelecteds)
        }
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
