//
//  RealmManagerTests.swift
//  English HelperTests
//
//  Created by 老房东 on 2022-02-07.
//

import XCTest
@testable import Learn_English_Helper

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Testing Structure: Given, When, Then

class RealmManager_Tests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UnitTestingRealmManager_syncFromServer_shouldBeOk() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        //Given
        var chapters : [Chapter]
        if let d: [Chapter] = load("example_picture.json"){
            chapters = d
        }else{
            chapters = []
        }
        XCTAssert(chapters.count > 0)
        
        //When
        let manager = RealmManager()
        manager.syncFromServer(chapters: chapters)
        let rchapters = manager.getAllChapters()
        
        //Then
        XCTAssertEqual(chapters.count, rchapters.count)
    }

    func testPerformance_RealmManager_syncFromServer() throws {
        //Given
        var chapters : [Chapter]
        if let d: [Chapter] = load("example_picture.json"){
            chapters = d
        }else{
            chapters = []
        }
        let manager = RealmManager()
        manager.syncFromServer(chapters: chapters)
        
        //When
        self.measure {
            // Put the code you want to measure the time of here.
            for _ in 0...99 {
                let _ = manager.getUniqExam(answerLength: 6)
            }
        }
        
    }

    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
