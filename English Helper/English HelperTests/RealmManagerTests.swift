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

class RealmManagerTests: XCTestCase {
    var realmManager : RealmManager?
    var chapters : [Chapter]?
    
    override func setUpWithError() throws {
        realmManager = RealmManager.instance
        if let d: [Chapter] = load("example_picture.json"){
            chapters = d
        }else{
            chapters = []
        }
        if let realmManager = realmManager, let chapters = chapters {
            realmManager.syncFromServer(chapters: chapters)
        }else{
            XCTFail()
        }
        
    }

    override func tearDownWithError() throws {
        guard let realmManager = realmManager else {
            XCTFail("realmManager not ready")
            return
        }
        realmManager.cleanRealm()
        chapters = nil
    }

    func test_UnitTestingGetUniqExam_Default_shouldBe100Answer() throws {
        //Given
        guard let realmManager = realmManager else {
            XCTFail("realmManager not ready")
            return
        }
        
        guard let chapters = chapters else {
            XCTFail("chapters not ready")
            return
        }
        
        //When
        let rChapters = realmManager.getAllChapters()
        realmManager.genExamRealm()
        for _ in 0...100{
            let exam = realmManager.getUniqExam(answerLength: 6)
            if exam == nil {
                XCTFail()
            }
        }
        
        //Then
        XCTAssertEqual(chapters.count, rChapters.count)
    }
    
    func test_unitTestingGenExamRealm_OneChapterSelect_shouldNotBe100Words() throws {
        //Given
        guard let realmManager = realmManager else {
            XCTFail("realmManager not ready")
            return
        }
        
        // When
        realmManager.genExamRealm()
        
        //Then
        print("memoRealmWordCount: \(realmManager.memoRealmWordCount)")
        XCTAssert(realmManager.memoRealmWordCount > 100)
        
        // When
        let rChapters = realmManager.getAllChapters()
        for i in 1..<rChapters.count{
            realmManager.toggleChapter(chapter: rChapters[i])
        }
        realmManager.genExamRealm()
        
        //Then
        print("memoRealmWordCount: \(realmManager.memoRealmWordCount)")
        XCTAssert(realmManager.memoRealmWordCount < 100)
    }
    
    func test_UnitTestingGetUniqExam_Default_shouldNotBe100Answer() throws {
        //Given
        guard let realmManager = realmManager else {
            XCTFail("realmManager not ready")
            return
        }
        guard let chapters = chapters else {
            XCTFail("chapters not ready")
            return
        }
        
        //When
        let rChapters = realmManager.getAllChapters()
        XCTAssertEqual(chapters.count, rChapters.count)
        for i in 1..<rChapters.count{
            realmManager.toggleChapter(chapter: rChapters[i])
        }
        realmManager.genExamRealm()
        var count = 0
        var nilCount = 0
        for _ in 0...100{
            let exam = realmManager.getUniqExam(answerLength: 6)
            if exam == nil {
                nilCount += 1
            }else{
                count += 1
            }
        }
        
        //Then
        print("count: \(count) nil: \(nilCount)")
        XCTAssertTrue(count > 1)
        XCTAssertTrue(nilCount > 1)
        
    }
    
    func test_UnitTestingDeleteMemoRealmWord_SetOneChapterIsSelect_shouldSameCount() throws{
        // 测试能正常清除所有的选中chapter中的单词
        //Given
        guard let realmManager = realmManager else {
            XCTFail("realmManager not ready")
            return
        }
        
        //When
        // 清除到只有一个chapter保持在isSelect=ture的状态
        let rChapters = realmManager.getAllChapters()
        for i in 1..<rChapters.count{
            realmManager.toggleChapter(chapter: rChapters[i])
        }
        // 生成测试题目的范围
        realmManager.genExamRealm()
        
        //Then
        let count = realmManager.memoRealmWordCount
        for _ in 1...count{
            // 从题库范围中生成一道题
            if let exam = realmManager.getRandomExam(answerLength: 6) {
                realmManager.deleteMemoRealmWord(word: exam.questionWord, pictureFileName: exam.answers[exam.correctAnswer].name)
            }
        }
        XCTAssertEqual(realmManager.memoRealmWordCount, 0)
    }

    func testPerformance_RealmManager_Default_shouldBe100Answer() throws {
        //Given
        guard let realmManager = realmManager else {
            XCTFail("realmManager not ready")
            return
        }
        //When
        self.measure {
            // Put the code you want to measure the time of here.
            realmManager.genExamRealm()
            for _ in 0...99 {
                let exam = realmManager.getUniqExam(answerLength: 6)
                if exam == nil {
                    XCTFail()
                }
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
