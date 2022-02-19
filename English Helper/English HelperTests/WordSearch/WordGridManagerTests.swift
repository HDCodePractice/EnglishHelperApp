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
        print(manager.wordsMap)
        
        //Then
        XCTAssertEqual(manager.grid.count,10)
        XCTAssertEqual(manager.grid[0].count,10)
    }
}
