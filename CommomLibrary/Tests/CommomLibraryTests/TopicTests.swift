//
//  TopicTests.swift
//  
//
//  Created by 老房东 on 2022-05-27.
//

import XCTest
import RealmSwift
@testable import CommomLibrary

class TopicTests: XCTestCase {

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


    func test_toggleSelect_whenToggleAboudCount() throws {
        guard let localRealm = realmController.localRealm else {return}
        
        let topics = localRealm.objects(Topic.self)
        let topicSelects = localRealm.objects(TopicSelect.self)
        let queryTopics = localRealm.objects(Topic.self)
        
        XCTAssertEqual(topics.count, 25)
        XCTAssertEqual(topicSelects.count, 0)
        
        // 初始的topic状态
        let topic = topics[0]
        XCTAssertEqual(topic.isSelected, true)
        XCTAssertEqual(topicSelects.count, 0)
        XCTAssertEqual( queryTopics.where { topic in
            Topic.isSelectedFilter(localRealm: localRealm, topic: topic)
        }.count, 25)
        
        // 点击一次
        topic.toggleSelect()
        let topicSelect = localRealm.object(ofType: TopicSelect.self, forPrimaryKey: topic.name)!
        XCTAssertEqual(topic.isSelected, false)
        XCTAssertEqual(topicSelects.count, 1)
        XCTAssertEqual(topic.name, topicSelect.name)
        XCTAssertEqual(topicSelect.isDeleted, false)
        XCTAssertEqual(topicSelect.isSelected, false)
        XCTAssertEqual( queryTopics.where { topic in
            Topic.isSelectedFilter(localRealm: localRealm, topic: topic)
        }.count, 24)
        
        // 点击第二次
        topic.toggleSelect()
        XCTAssertEqual(topic.isSelected, true)
        XCTAssertEqual(topicSelects.count, 1)
        XCTAssertEqual(topic.name, topicSelect.name)
        XCTAssertEqual(topicSelect.isDeleted, false)
        XCTAssertEqual(topicSelect.isSelected, true)
        XCTAssertEqual( queryTopics.where { topic in
            Topic.isSelectedFilter(localRealm: localRealm, topic: topic)
        }.count, 25)
        
        topic.delete()
        XCTAssertEqual(topicSelect.isDeleted, true)
    }

}
