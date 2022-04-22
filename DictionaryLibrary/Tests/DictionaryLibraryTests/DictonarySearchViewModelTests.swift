//
//  DictonarySearchViewModelTests.swift
//  
//
//  Created by 老房东 on 2022-04-20.
//

import XCTest
@testable import DictionaryLibrary

class DictonarySearchViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFilteredTopicList() throws {
        //Give
        let vm = DictonarySearchViewModel(isPreview: true)
        
        //When
        vm.setFilteredTopicList(searchFilter: "")
        //Then
        XCTAssertEqual(vm.filteredTopics.count, 0)
        
        //When
        vm.setFilteredTopicList(searchFilter: "b")
        print(vm.filteredTopics)
    }
}
