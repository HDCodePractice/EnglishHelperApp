//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation
import RealmSwift
import OSLog
import IceCream
import OSLog

public class Word: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) public var id: String
    @Persisted(indexed: true) public var name: String
    @Persisted public var isFavorited: Bool = false
    @Persisted(originProperty: "words") public var assignee: LinkingObjects<Picture>
}

public extension Word{
    var isNew: Bool{
        if let localRealm = self.realm{
            let count = localRealm.objects(WordSelect.self).where {
                $0.id==self.id && $0.isNew==false
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
        if let wordSelect = localRealm.object(ofType: WordSelect.self, forPrimaryKey: self.id){
            wordSelect.deleteTransaction(localRealm)
        }
        localRealm.delete(self)
    }
    
    func setIsNew(isNew:Bool){
        if let thawed=self.thaw(), let localRealm = thawed.realm {
            do{
                try localRealm.write{
                    self.setIsNewTransaction(localRealm: localRealm, isNew: isNew)
                }
            }catch{
                Logger().error("setWordSelect \(self.name) error: \(error.localizedDescription)")
            }
        }
    }
    
    func setIsNewTransaction(localRealm:Realm, isNew:Bool){
        if let wordSelect = localRealm.object(ofType: WordSelect.self, forPrimaryKey: self.id){
            wordSelect.isNew = isNew
        }else{
            WordSelect.addNewWordSelectTransaction(
                localRealm: localRealm,
                id: self.id,
                name: self.name,
                isNew: isNew
            )
        }
    }
    
    /// 生成isNew的查询表达式
    /// - Parameters:
    ///   - localRealm: 可用的Realm实例
    ///   - word: 执行where查询的word实例
    /// - Returns: 查询表达式
    static func isNewFilter(localRealm:Realm, isNew:Bool=true, word: Query<Word>) -> Query<Bool> {
        // 准备好subquery
        let wordSelects = localRealm.objects(WordSelect.self)
        // 找出所有isNew为false的word id
        var isNotSelecteds: [String] = wordSelects.where { select in
            select.isNew==false && select.isDeleted==false
        }.map{ $0.id }
        if isNotSelecteds.count==0{
            isNotSelecteds = [""]
        }
        if isNew{
            return !word.id.in(isNotSelecteds)
        }else{
            return word.id.in(isNotSelecteds)
        }
    }
    
    static func isNewFilter(localRealm:Realm, isNew:Bool=true, words: Query<List<Word>>) -> Query<Bool> {
        // 准备好subquery
        let wordSelects = localRealm.objects(WordSelect.self)
        // 找出所有isNew为false的word id
        var isNotSelecteds: [String] = wordSelects.where { select in
            select.isNew==false && select.isDeleted==false
        }.map{ $0.id }
        if isNotSelecteds.count==0{
            isNotSelecteds = [""]
        }
        if isNew{
            return !words.id.in(isNotSelecteds)
        }else{
            return words.id.in(isNotSelecteds)
        }
    }
    
    static func setAllIsNewTransaction(localRealm:Realm, isNew: Bool){
        let words = localRealm.objects(Word.self).where{ word in
            isNewFilter(localRealm: localRealm, isNew: !isNew, word: word)
        }
        for word in words{
            word.setIsNewTransaction(localRealm: localRealm, isNew: isNew)
        }
    }
    
    func setIsFavorited(isFavorited:Bool){
        if let thawed=self.thaw(), let localRealm = thawed.realm {
            do{
                try localRealm.write{
                    self.setIsFavoritedTransaction(localRealm: localRealm, isFavorited: isFavorited)
                }
            }catch{
                Logger().error("setWordSelect \(self.name) error: \(error.localizedDescription)")
            }
        }
    }
    
    func setIsFavoritedTransaction(localRealm:Realm, isFavorited:Bool){
        if let wordSelect = localRealm.object(ofType: WordSelect.self, forPrimaryKey: self.id){
            wordSelect.isFavorited = isFavorited
        }else{
            WordSelect.addNewWordSelectTransaction(
                localRealm: localRealm,
                id: self.id,
                name: self.name,
                isFavorited: isFavorited
            )
        }
    }
}

public extension Word{
    var words : [String]{
        var ws : [String] = []
        if let picture=self.assignee.first{
            for w in picture.words{
                ws.append(w.name)
            }
        }
        return ws
    }
    
    var wordsTitle: String{
        var title=""
        if words.isEmpty{
            return ""
        }
        if words.count == 1{
            return words[0]
        }
        for i in 0..<words.count-1 {
            title += words[i]
            title += " / "
        }
        title += words[words.count-1]
        return title
    }
    
    var chapterName:String{
        if let picture=self.assignee.first,
           let topic=picture.assignee.first,
           let chapter=topic.assignee.first{
            return chapter.name
        }
        return ""
    }
    
    var topicName:String{
        if let picture=self.assignee.first,
           let topic=picture.assignee.first{
            return topic.name
        }
        return ""
    }
    
    var fileName:String{
        if let picture=self.assignee.first{
            return picture.name
        }
        return ""
    }
    
    var filePath:String{
        if let picture=self.assignee.first,
           let topic=picture.assignee.first,
           let chapter=topic.assignee.first{
            let chapterName = chapter.name
            let topicName = topic.name
            let fileName = picture.name
            return "\(chapterName)/\(topicName)/\(fileName)"
        }
        return ""
    }
    
    var audioFilePath:String{
        if let picture=self.assignee.first,
           let topic=picture.assignee.first,
           let chapter=topic.assignee.first{
            let chapterName = chapter.name
            let topicName = topic.name
            let fileName = self.name
            return "\(chapterName)/\(topicName)/\(fileName)"
        }
        return ""
    }
    
    var audioUrl:String{
        return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/audio/\(audioFilePath).wav".urlEncoded()
    }
    
    var pictureUrl:String{
        return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/\(filePath)".urlEncoded()
    }
    
    func toggleFavorite(){
        if let thawWord = self.thaw(){
            if let localRealm = thawWord.realm{
                do{
                    try localRealm.write{
                        thawWord.isFavorited.toggle()
                    }
                } catch {
                    Logger().error("Error toggle isFavorite \(self) from Realm: \(error.localizedDescription)")
                }
            }
        }
    }
}
