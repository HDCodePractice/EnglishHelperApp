//
//  LoadJsonTests.swift
//  
//
//  Created by 老房东 on 2022-05-20.
//

import XCTest
import Foundation
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
    
    func testLoadPictureJsonFromRemote() async throws {
        let pictureJsonURL="https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"
        if let jChapter:[JChapter] = await loadDataByServer(url: pictureJsonURL){
            XCTAssertTrue(jChapter.count > 0)
        }
    }
    
    func testLoadIrregularVerJsonFromRemote() async throws {
        let url="https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/iverbs.json"
        do{
            let (data,_) = try await URLSession.shared.data(from: URL(string: url)!)
            if let jsons = try! JSONSerialization.jsonObject(with: data, options: []) as? [Any]{
                XCTAssertTrue(jsons.count > 0)
            }
        }catch{
            print("load \(url) error:\(error)")
        }
    }
}
