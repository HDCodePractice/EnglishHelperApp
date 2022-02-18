//
//  WordGridGeneratorTests.swift
//  English HelperTests
//
//  Created by 老房东 on 2022-02-12.
//

import XCTest
@testable import Learn_English_Helper

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Testing Structure: Given, When, Then
class WordGridGeneratorTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_UnitGenerate_NormalWords_shouldOk() throws{
        // Given
        let words = ["hello","world","swiftui","is","cool"]
        let row = 9
        let column = 9
        let wordGridGenerator = WordGridGenerator(words: words, row: row, column: column)
        
        //When
        let wordGrid = wordGridGenerator.generate()
        
        // Then
        XCTAssertEqual(wordGrid!.count, row)
        XCTAssertEqual(wordGrid![0].count, column)
        print(wordGridGenerator.wordsMap)
        XCTAssertEqual(wordGridGenerator.wordsMap.count, words.count)
    }

    func test_UnitGenerate_NormalWords_shouldReturnNil() throws{
        // Given
        let words = ["hello","world","swiftui","is","cool"]
        let row = 5
        let column = 5
        let wordGridGenerator = WordGridGenerator(words: words, row: row, column: column)
        
        //When
        let wordGrid = wordGridGenerator.generate()
        
        // Then
        XCTAssertEqual(wordGrid, nil)
    }
    
}
