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
            let chapterSelects = localRealm.objects(ChapterSelect.self).where {
                $0.name==self.name
            }
            localRealm.writeAsync{
                if chapterSelects.count==0{
                    ChapterSelect.addNewChapterSelectTransaction(
                        localRealm: localRealm,
                        name: self.name,
                        isSelected: isSelected ?? false
                    )
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
