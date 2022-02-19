//
//  WordGridManagerTests.swift
//  English HelperTests
//
//  Created by 老房东 on 2022-02-14.
//

import XCTest
@testable import Learn_English_Helper

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Testing Structure: Given, When, Then

class WordGridManagerTests: XCTestCase {
    var manager : WordGridManager = WordGridManager()
    
    override func setUpWithError() throws {
        manager = WordGridManager()
    }
    
    override func tearDownWithError() throws {
    }
    
    func testUnitGeneratorWordGrid_init_shouldIsOk() throws {
        // Given
        manager.words = ["hello","world","swiftui","is","cool"]
        manager.row = 10
        manager.column = 10
        
        //When
        manager.generatorWordGrid()
        
        //Then
        XCTAssertEqual(manager.grid.count,10)
        XCTAssertEqual(manager.grid[0].count,10)
    }
    
    func testUnitGetWordByPosition() throws{
        // Given
        manager.words = ["hello","world","swiftui","is","cool"]
        manager.row = 10
        manager.column = 10
        manager.generatorWordGrid()
        
        // When
        for i in 0...5{
            for j in 0...5{
                manager.grid[i][j].character = Character("\(j)")
            }
        }
        
        // Then
        let one = manager.getWordByPosition(start: Position(row: 0, col: 0), end: Position(row: 0, col: 0))
        XCTAssertEqual(one, "0")
        let leftRight = manager.getWordByPosition(start: Position(row: 0, col: 0), end: Position(row: 0, col: 5))
        XCTAssertEqual(leftRight, "012345")
        let rightLeft = manager.getWordByPosition(start: Position(row: 0, col: 5), end: Position(row: 0, col: 0))
        XCTAssertEqual(rightLeft, "543210")
        let topLeftRight = manager.getWordByPosition(start: Position(row: 1, col: 1), end: Position(row: 5, col: 5))
        XCTAssertEqual(topLeftRight, "12345")
        let bottomLeftRight = manager.getWordByPosition(start: Position(row: 5, col: 0), end: Position(row: 0, col: 5))
        XCTAssertEqual(bottomLeftRight, "012345")
    }
}
