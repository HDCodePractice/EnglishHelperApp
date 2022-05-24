//
//  PictureTest.swift
//  
//
//  Created by 老房东 on 2022-04-29.
//

import XCTest
@testable import CommomLibrary

class PictureTests: XCTestCase {

    var realmController : RealmController  = RealmController()
    var jchapters : [JChapter] = []
    
    override func setUpWithError() throws {
        realmController = RealmController()
        
        for i in 1...5 {
            var newChapter = JChapter(name: "Chapter\(i)")
            for j in 1...5{
                var newTopic=JTopic(name: "Topic\(j)")
                for k in 1...5{
                    let newPictureFile=JPictureFile(id: "\(i)\(j)\(k)", name: "Pic\(k)", words: ["words\(i)\(j)\(k)1","words\(i)\(j)\(k)2"])
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

    func testPictureURL() throws {
        // When
        let pic = realmController.localRealm?.objects(Picture.self).first
        
        // Then
        if let pic = pic {
            XCTAssertEqual(pic.pictureUrl, "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Chapter1/Topic1/Pic1.jpg")
        }else{
            XCTAssertNotNil(pic, "Not Have Picture")
        }
    }
}
