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
    // 删除数据库中指定的chapter记录
    func delete(_ isAsync:Bool=false) {
        if let thawed=self.thaw(), let localRealm = thawed.realm{
            do{
                for topic in self.topics{
                    topic.delete()
                }
                if isAsync{
                    localRealm.writeAsync{
                        localRealm.delete(self)
                    } onComplete: { error in
                        if let error=error{
                            Logger().error("Error deleting chapter \(self) from Realm: \(error.localizedDescription)")
                        }
                    }
                }else{
                    try localRealm.write{
                        localRealm.delete(self)
                    }
                }
            } catch {
                Logger().error("Error deleting chapter \(self) from Realm: \(error.localizedDescription)")
            }
        }
    }
    
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
    
    func toggleSelect(){
        setChapterSelect(isToggle: true)
    }
    
    func setChapterSelect(isSelected:Bool){
        setChapterSelect(isToggle: false, isSelected: isSelected)
    }
    
    private func setChapterSelect(isToggle:Bool,isSelected:Bool?=nil){
        if let thawed=self.thaw(), let localRealm = thawed.realm {
            localRealm.writeAsync{
                let chapterSelects = localRealm.objects(ChapterSelect.self).where {
                    $0.name==self.name
                }
                
                if chapterSelects.count==0{
                    let chapterSelect = ChapterSelect(value: [
                        "name": self.name,
                        // 如果isSelected存在用它，不存在说明要toggle，则变为false
                        "isSelected":isSelected ?? false
                    ])
                    localRealm.add(chapterSelect)
                }else if let chapterSelect = chapterSelects.first{
                    if isToggle{
                        chapterSelect.isSelected.toggle()
                    }else{
                        if let isSelected=isSelected{
                            chapterSelect.isSelected=isSelected
                        }
                    }
                }
            } onComplete: { error in
                if let error=error {
                    Logger().error("setChapterSelect \(self.name) error: \(error.localizedDescription)")
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
