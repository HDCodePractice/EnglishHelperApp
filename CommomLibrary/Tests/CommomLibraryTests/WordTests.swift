//
//  WordTests.swift
//  
//
//  Created by 老房东 on 2022-05-28.
//

import XCTest
import RealmSwift
@testable import CommomLibrary

class WordTests: XCTestCase {
    var realmController : RealmController  = RealmController()
    var jchapters : [JChapter] = []
    
    override func setUpWithError() throws {
        realmController = RealmController()
        realmController.localRealm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
        
        for i in 1...5 {
            var newChapter = JChapter(name: "Chapter\(i)")
            for j in 1...5{
                var newTopic=JTopic(name: "Topic\(i)\(j)")
                for k in 1...5{
                    let newPictureFile=JPictureFile(name: "Pic\(k)", words: ["words\(i)\(j)\(k)1","words\(i)\(j)\(k)2"])
                    newTopic.pictureFiles.append(newPictureFile)
                }
                newChapter.topics.append(newTopic)
            }
            jchapters.append(newChapter)
        }
        realmController.syncFromServer(chapters: jchapters)
    }

    override func tearDownWithError() throws {
        realmController.cleanRealm()
        jchapters = []
    }

    func test_Word_whenTopicToogleAboutCount() throws {
        guard let localRealm = realmController.localRealm else { return }
     
        XCTAssertEqual(localRealm.objects(Chapter.self).count, 5)
        XCTAssertEqual(localRealm.objects(Topic.self).count, 25)
        XCTAssertEqual(localRealm.objects(Picture.self).count, 125)
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        // 初始
        let topic=localRealm.object(ofType: Topic.self, forPrimaryKey: "Topic11")!
        let words=localRealm.objects(Word.self)
        XCTAssertEqual(words.where({ $0.assignee.assignee.name==topic.name}).count , 10)
        XCTAssertEqual(words.where({ Topic.isSelectedFilter(localRealm: localRealm, isSelected: false, assignee: $0.assignee.assignee) }).count , 0)
        XCTAssertEqual(words.where({ Topic.isSelectedFilter(localRealm: localRealm, isSelected: true, assignee: $0.assignee.assignee) }).count , 250)
        // 取消一个topic的选择
        topic.toggleSelect()
        XCTAssertEqual(words.where({ Topic.isSelectedFilter(localRealm: localRealm, isSelected: false, assignee: $0.assignee.assignee) }).count , 10)
        XCTAssertEqual(words.where({ Topic.isSelectedFilter(localRealm: localRealm, isSelected: true, assignee: $0.assignee.assignee) }).count , 240)
    }
    
    func test_setAllIsNewTransaction_whenCleanAllNewAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        XCTAssertEqual(localRealm.objects(WordSelect.self).count, 0)
        // cleanAllNew
        localRealm.writeAsync{
            Word.setAllIsNewTransaction(localRealm: localRealm, isNew: false)
        } onComplete: { error in
            XCTAssertNil(error)
            XCTAssertEqual(localRealm.objects(WordSelect.self).count, 250)
            XCTAssertEqual(localRealm.objects(WordSelect.self).where({$0.isNew==false}).count, 250)
        }
    }
    
    func test_setAllIsNewTransaction_whenSetAllNewAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        XCTAssertEqual(localRealm.objects(WordSelect.self).count, 0)
        // SetAllNew
        localRealm.writeAsync{
            Word.setAllIsNewTransaction(localRealm: localRealm, isNew: false)
            Word.setAllIsNewTransaction(localRealm: localRealm, isNew: true)
        } onComplete: { error in
            XCTAssertNil(error)
            XCTAssertEqual(localRealm.objects(WordSelect.self).count, 250)
            XCTAssertEqual(localRealm.objects(WordSelect.self).where({$0.isNew==true}).count, 250)
        }
    }
    
    func test_isNewFilter_whenSomeWordNotNewAboutChaptersCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        let chapters = localRealm.objects(Chapter.self)
        let words = localRealm.objects(Word.self)
        
        var count = chapters.count
        XCTAssertEqual(count, 5)
        XCTAssertEqual(words.count, 250)
        XCTAssertEqual(words[0].isNew,true)
        
        words[0].setIsNew(isNew: false)
        count = words.where{
            Word.isNewFilter(localRealm: localRealm, isNew: true, word: $0)
        }.count
        XCTAssertEqual(count, 249)
        count = chapters.where{
            Word.isNewFilter(localRealm: localRealm, isNew: true, words: $0.topics.pictures.words)
        }.count
        XCTAssertEqual(count, 4)
    }
}
