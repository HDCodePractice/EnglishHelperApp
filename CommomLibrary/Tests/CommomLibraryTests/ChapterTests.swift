//
//  ChapterTests.swift
//  
//
//  Created by 老房东 on 2022-05-26.
//

import XCTest
import RealmSwift
@testable import CommomLibrary

class ChapterTests: XCTestCase {

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

    func test_givePicture_whenChapterDeleteAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        XCTAssertEqual(localRealm.objects(Chapter.self).count, 5)
        XCTAssertEqual(localRealm.objects(Topic.self).count, 25)
        XCTAssertEqual(localRealm.objects(Picture.self).count, 125)
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        
        let chapter = localRealm.objects(Chapter.self).randomElement()!
        XCTAssertNil(localRealm.object(ofType: ChapterSelect.self, forPrimaryKey: chapter.name))
        chapter.toggleSelect()
        XCTAssertEqual(chapter.isSelected, false)
        XCTAssertNotNil(localRealm.object(ofType: ChapterSelect.self, forPrimaryKey: chapter.name))
        let chapterSelect = localRealm.object(ofType: ChapterSelect.self, forPrimaryKey: chapter.name)!
        XCTAssertEqual(chapterSelect.isDeleted, false)
        XCTAssertEqual(chapterSelect.isSelected, false)
        chapter.toggleSelect()
        XCTAssertEqual(chapterSelect.isSelected, true)
        
        chapter.delete()
        XCTAssertEqual(localRealm.objects(Chapter.self).count, 4)
        XCTAssertEqual(localRealm.objects(Topic.self).count, 20)
        XCTAssertEqual(localRealm.objects(Picture.self).count, 100)
        XCTAssertEqual(localRealm.objects(Word.self).count, 200)
        XCTAssertEqual(chapterSelect.isDeleted, true)
    }

    func test_givePicture_whenChapterAsyncDeleteAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        XCTAssertEqual(localRealm.objects(Chapter.self).count, 5)
        XCTAssertEqual(localRealm.objects(Topic.self).count, 25)
        XCTAssertEqual(localRealm.objects(Picture.self).count, 125)
        XCTAssertEqual(localRealm.objects(Word.self).count, 250)
        
        let expectation = XCTestExpectation(description: "delete called")
        expectation.expectedFulfillmentCount = 2
        
        let chapters = localRealm.objects(Chapter.self)
        chapters[0].delete(isAsync: true){ _ in
            XCTAssertEqual(localRealm.objects(Chapter.self).count, 4)
            XCTAssertEqual(localRealm.objects(Topic.self).count, 20)
            XCTAssertEqual(localRealm.objects(Picture.self).count, 100)
            XCTAssertEqual(localRealm.objects(Word.self).count, 200)
            expectation.fulfill()
        }
        chapters[1].delete(isAsync: true){ _ in
            XCTAssertEqual(localRealm.objects(Chapter.self).count, 3)
            XCTAssertEqual(localRealm.objects(Topic.self).count, 15)
            XCTAssertEqual(localRealm.objects(Picture.self).count, 75)
            XCTAssertEqual(localRealm.objects(Word.self).count, 150)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    
}
