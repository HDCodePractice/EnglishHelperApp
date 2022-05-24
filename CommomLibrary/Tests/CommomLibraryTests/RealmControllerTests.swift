//
//  RealmControllerTests.swift
//  
//
//  Created by 老房东 on 2022-04-20.
//

import XCTest
@testable import CommomLibrary

class RealmControllerTests: XCTestCase {

    var realmController : RealmController  = RealmController()
    var jchapters : [JChapter] = []
    
    override func setUpWithError() throws {
        realmController = RealmController()
        
        for i in 1...5 {
            var newChapter = JChapter(name: "Chapter\(i)")
            for j in 1...5{
                var newTopic=JTopic(name: "Topic\(j)")
                for k in 1...5{
                    let newPictureFile=JPictureFile(id:"ijk",name: "Pic\(k)", words: ["words\(i)\(j)\(k)1","words\(i)\(j)\(k)2"])
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

    func test_GetAllChapters_CountedShouldBeEqueal5() throws {
        //Given
        //When
        //Then
        let chapters = realmController.getAllChapters()
        XCTAssertEqual(chapters.count, 5)
        XCTAssertEqual(chapters[0].topics.count, 5)
        XCTAssertEqual(chapters[0].topics[0].pictures.count, 5)
        XCTAssertEqual(chapters[0].topics[0].pictures[0].words.count, 2)
    }
    
    func test_SyncFromServer_HaveNewData() throws {
        // Add new chapter
        //Given
        jchapters.append(
            JChapter(name: "newChapter", topics: [
                JTopic( name: "newTopic", pictureFiles: [
                    JPictureFile(id: "newChapternewTopicnewPic", name: "newPic", words: ["newWord"])
                ])
            ])
        )
        //When
        realmController.syncFromServer(chapters: jchapters)
        //Then
        var chapters = realmController.getAllChapters()
        XCTAssertEqual(chapters.count, 6)
        XCTAssertEqual(chapters[5].topics.count, 1)
        XCTAssertEqual(chapters[5].topics[0].pictures.count, 1)
        XCTAssertEqual(chapters[5].topics[0].pictures[0].words.count, 1)

        // Add new word
        //Given
        jchapters[0].topics[0].pictureFiles[0].words.append("newWord1")
        //When
        realmController.syncFromServer(chapters: jchapters)
        //Then
        chapters = realmController.getAllChapters()
        XCTAssertEqual(chapters[0].topics[0].pictures[0].words.count, 3)
    }
    
    func test_SyncFromServer_HadDeletData() throws {
        //Given
        jchapters[0].topics[0].pictureFiles.remove(at: 0)
        
        //When
        realmController.syncFromServer(chapters: jchapters)
        //Then
        var chapters = realmController.getAllChapters()
        XCTAssertEqual(chapters.count, 5)
        XCTAssertEqual(chapters[0].topics.count, 5)
        XCTAssertEqual(chapters[0].topics[0].pictures.count, 4)
        XCTAssertEqual(chapters[0].topics[0].pictures[0].words.count, 2)
        
        //Given
        jchapters[0].topics[0].pictureFiles[0].words.remove(at: 0)
        
        //When
        realmController.syncFromServer(chapters: jchapters)
        //Then
        chapters = realmController.getAllChapters()
        print(jchapters[0].topics[0].pictureFiles[0])
        print(chapters[0].topics[0].pictures[0])
        XCTAssertEqual(chapters.count, 5)
        XCTAssertEqual(chapters[0].topics.count, 5)
        XCTAssertEqual(chapters[0].topics[0].pictures.count, 4)
        XCTAssertEqual(chapters[0].topics[0].pictures[0].words.count, 1)
    }
    
    func test_SyncFromServer_ChangedData() throws {
        //Give
        //When
        jchapters[0].topics[0].pictureFiles[0].words[0]="newWord"
        realmController.syncFromServer(chapters: jchapters)
        var chapters = realmController.getAllChapters()
        //Than
        XCTAssertEqual(chapters[0].topics[0].pictures[0].words[1].name, "newWord")
        
        //When
        jchapters[0].topics[0].pictureFiles[0].name="newPic"
        realmController.syncFromServer(chapters: jchapters)
        chapters = realmController.getAllChapters()
        //Than
        XCTAssertEqual(chapters[0].topics[0].pictures[4].name, "newPic")
        XCTAssertEqual(chapters[0].topics[0].pictures[4].words[0].name, "newWord")
    }
}
