//
//  PictureGameViewModelTests.swift
//  
//
//  Created by 老房东 on 2022-04-28.
//

import XCTest
@testable import PictureGame

class PictureGameViewModelTests: XCTestCase {
    
    var vm = PictureGameViewModel(isPreview: true)
    
    override func setUpWithError() throws {
        vm.reloadPreviewData()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeneratePictureExam() throws {
        vm.generatePictureExam()
        print(vm.audioFile)
        print(vm.answerChoices[0])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
