//
//  WordSearchGeneratorTests.swift
//  English HelperTests
//
//  Created by 老房东 on 2022-02-18.
//

import XCTest
@testable import Learn_English_Helper

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Testing Structure: Given, When, Then

class WordSearchGeneratorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UnitMakeGrid() throws {
        let wg = WordSearchGenerator()
        wg.words = [
            WordCell(title: "hello"),
            WordCell(title: "swift ui"),
            WordCell(title: "english"),
            WordCell(title: "your are good student")
        ]
        wg.difficulty = .hard
        wg.makeGrid()
        print(wg.printGrid())
        XCTAssertEqual(wg.cells.count, wg.nRow)
        XCTAssertEqual(wg.cells[0].count, wg.nColumn)
    }
}
