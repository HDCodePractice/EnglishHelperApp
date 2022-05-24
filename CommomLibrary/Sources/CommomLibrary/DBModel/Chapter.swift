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
    
    func toggleSelect(){
        setChapterSelect(isToggle: true)
    }
    
    func setChapterSelect(isSelected:Bool){
        setChapterSelect(isToggle: false, isSelected: isSelected)
    }
    
    private func setChapterSelect(isToggle:Bool,isSelected:Bool?=nil){
        if let thawed=self.thaw(), let localRealm = thawed.realm {
            do{
                try localRealm.write{
                    
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
                }
            }catch{
                Logger().error("setChapterSelect \(self.name) error: \(error.localizedDescription)")
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
