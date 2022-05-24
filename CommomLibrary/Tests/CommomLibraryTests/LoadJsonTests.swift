//
//  LoadJsonTests.swift
//  
//
//  Created by 老房东 on 2022-05-20.
//

import XCTest
@testable import CommomLibrary

class LoadJsonTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadJsonFromExample() throws {
        let jsonFile="example.json"
        if let chapters: [JChapter] = CommomLibrary.load(jsonFile,bundel: .swiftUIPreviewsCompatibleModule){
            print(chapters)
        }
    }
    
    func testLoadJsonFromRemote() async throws {
        let pictureJsonURL="https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"
        if let jChapter:[JChapter] = await loadDataByServer(url: pictureJsonURL){
            print(jChapter)
        }
    }
}
