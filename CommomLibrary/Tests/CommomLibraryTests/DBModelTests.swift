//
//  PictureTest.swift
//  
//
//  Created by 老房东 on 2022-04-29.
//

import XCTest
import RealmSwift
@testable import CommomLibrary

class PictureTests: XCTestCase {

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

    func testWhenInitRealmShouldReady() throws {
        // When
        let pic = realmController.localRealm?.objects(Picture.self).first
        
        // Then
        if let pic = pic {
            XCTAssertEqual(pic.pictureUrl, "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Chapter1/Topic11/Pic1")
        }else{
            XCTAssertNotNil(pic, "Not Have Picture")
        }
        
        let chapterCount = realmController.localRealm?.objects(Chapter.self).count ?? 0
        XCTAssertEqual(chapterCount, 5)
        let topicCount = realmController.localRealm?.objects(Topic.self).count ?? 0
        XCTAssertEqual(topicCount, 25)
        let pictureCount = realmController.localRealm?.objects(Picture.self).count ?? 0
        XCTAssertEqual(pictureCount, 125)
        let wordCount = realmController.localRealm?.objects(Word.self).count ?? 0
        XCTAssertEqual(wordCount, 250)
        let chapterSelectCount = realmController.localRealm?.objects(ChapterSelect.self).count ?? -1
        XCTAssertEqual(chapterSelectCount, 0)
    }
    
    func test_giveWord_whenWordDeleteAboutCount() throws{
        XCTAssertEqual(realmController.localRealm!.objects(Word.self).count, 250)
        
        // 同步delete
        let word1 = realmController.localRealm!.objects(Word.self).randomElement()!
        word1.delete()
        XCTAssertEqual(realmController.localRealm!.objects(Word.self).count, 249)
    }
    
    func test_giveWord_whenWordAsyncDeleteOnceAboutCount(){
        guard let localRealm = realmController.localRealm else { return }
        
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        
        let words = localRealm.objects(Word.self)
        
        let expectation = XCTestExpectation(description: "delete called")
        
        words[0].delete(isAsync: true) { _ in
            let count = localRealm.objects(Word.self).count
            XCTAssertEqual(count, 249)
            print("deleted 1: \(count)")
            expectation.fulfill()
        }
        print("deleted: \(localRealm.objects(Word.self).count)")
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_giveWord_whenWordAsyncDeleteFourTimesAboutCount(){
        if let localRealm = realmController.localRealm{
            XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        }
        let words = realmController.localRealm!.objects(Word.self)
        
        let expectation1 = XCTestExpectation(description: "delete 1 called 2 times")
        expectation1.expectedFulfillmentCount = 2
        let expectation2 = XCTestExpectation(description: "delete 2 called")
        let expectation3 = XCTestExpectation(description: "delete 3 called")
        
        words[0].delete(isAsync: true) { _ in
            let count = self.realmController.localRealm!.objects(Word.self).count
            XCTAssertEqual(count, 249)
            print("deleted 1/1: \(count)")
            expectation1.fulfill()
        }
        
        words[0].delete(isAsync: true) { _ in
            let count = self.realmController.localRealm!.objects(Word.self).count
            XCTAssertEqual(count, 249)
            print("deleted 1/2: \(count)")
            expectation1.fulfill()
        }
        
        words[1].delete(isAsync: true) { _ in
            let count = self.realmController.localRealm!.objects(Word.self).count
            XCTAssertEqual(count, 248)
            print("deleted 2: \(count)")
            expectation2.fulfill()
        }
        
        words[2].delete(isAsync: true) { _ in
            let count = self.realmController.localRealm!.objects(Word.self).count
            XCTAssertEqual(count, 247)
            print("deleted 3: \(count)")
            expectation3.fulfill()
        }
        
        print("deleted: \(self.realmController.localRealm!.objects(Word.self).count)")
        wait(
            for: [expectation1,expectation2,expectation3],
            timeout: 2.0,
            enforceOrder: true
        )
    }
    
    func test_givePicture_whenPictureDeleteAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        XCTAssertEqual(localRealm.objects(Picture.self).count, 125)
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        
        
        let picture = localRealm.objects(Picture.self).randomElement()!
        
        picture.delete()
        XCTAssertEqual(localRealm.objects(Picture.self).count, 124)
        XCTAssertEqual(localRealm.objects(Word.self).count, 248)
    }
    
    func test_givePicture_whenPictureAsyncDeleteAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        XCTAssertEqual(localRealm.objects(Picture.self).count, 125)
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        
        let expectation = XCTestExpectation(description: "delete called")
        expectation.expectedFulfillmentCount = 2
        
        let pictures = localRealm.objects(Picture.self)
        pictures[0].delete(isAsync: true){ _ in
            XCTAssertEqual(localRealm.objects(Picture.self).count, 124)
            XCTAssertEqual(localRealm.objects(Word.self).count, 248)
            expectation.fulfill()
        }
        pictures[1].delete(isAsync: true){ _ in
            XCTAssertEqual(localRealm.objects(Picture.self).count, 123)
            XCTAssertEqual(localRealm.objects(Word.self).count, 246)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givePicture_whenTopicDeleteAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        XCTAssertEqual(localRealm.objects(Topic.self).count, 25)
        XCTAssertEqual(localRealm.objects(Picture.self).count, 125)
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        
        
        let topic = localRealm.objects(Topic.self).randomElement()!
        
        topic.delete()
        XCTAssertEqual(localRealm.objects(Topic.self).count, 24)
        XCTAssertEqual(localRealm.objects(Picture.self).count, 120)
        XCTAssertEqual(localRealm.objects(Word.self).count, 240)
    }
    
    func test_givePicture_whenTopicAsyncDeleteAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        XCTAssertEqual(localRealm.objects(Topic.self).count, 25)
        XCTAssertEqual(localRealm.objects(Picture.self).count, 125)
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        
        let expectation = XCTestExpectation(description: "delete called")
        expectation.expectedFulfillmentCount = 2
        
        let topics = localRealm.objects(Topic.self)
        topics[0].delete(isAsync: true){ _ in
            XCTAssertEqual(localRealm.objects(Topic.self).count, 24)
            XCTAssertEqual(localRealm.objects(Picture.self).count, 120)
            XCTAssertEqual(localRealm.objects(Word.self).count, 240)
            expectation.fulfill()
        }
        topics[1].delete(isAsync: true){ _ in
            XCTAssertEqual(localRealm.objects(Topic.self).count, 23)
            XCTAssertEqual(localRealm.objects(Picture.self).count, 115)
            XCTAssertEqual(localRealm.objects(Word.self).count, 230)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
