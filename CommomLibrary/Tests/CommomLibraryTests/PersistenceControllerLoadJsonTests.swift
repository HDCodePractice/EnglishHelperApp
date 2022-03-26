//
//  PersistenceControllerLoadJsonTests.swift
//  
//
//  Created by 老房东 on 2022-03-25.
//

import XCTest
import CoreData
@testable import CommomLibrary

class PersistenceControllerLoadJsonTests: XCTestCase {
    var viewContext : NSManagedObjectContext?

    override func setUpWithError() throws {
        let result = PersistenceController.preview
        viewContext = result.container.viewContext
    }

    override func tearDownWithError() throws {
        viewContext = nil
    }

    func testFetchChapterHasCorrect() throws {
        // Given
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        
        // When
        let fetchRequest: NSFetchRequest<Chapter> = Chapter.fetchRequest()
        let result = try! viewContext.fetch(fetchRequest)
        
        //Then
        XCTAssertEqual(result.count, 7)
        let checkList = [
            "Areas of study",
            "Clothing",
            "Community",
            "Everyday Language",
            "Health",
            "Plants and Animals",
            "Recreation"
        ]
        for chapter in result {
            XCTAssertTrue(checkList.contains(chapter.viewModel.name))
        }
    }
    
    func testFetchTopicHasCorrect() throws {
        // Given
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        
        // When
        let fetchRequest: NSFetchRequest<Topic> = Topic.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chapter.name = %@", "Health")
        let result = try! viewContext.fetch(fetchRequest)
        
        //Then
        XCTAssertEqual(result.count, 3)
        let checkList = [
            "The Body",
            "Symptoms and Injuries",
            "A Pharmacy"
        ]
        for topic in result {
            XCTAssertTrue(checkList.contains(topic.viewModel.name))
        }
    }
    
    func testFetchPictureHasCorrect() throws {
        // Given
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        
        // When
        let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "topic.name = %@", "A Pharmacy")
        let result = try! viewContext.fetch(fetchRequest)
        
        //Then
        XCTAssertEqual(result.count, 11)
        let checkList = [
            "wheelchair.jpg",
            "prescribe.jpg",
            "prescription medicine.jpg",
            "cream.jpg",
            "prescription.jpg",
            "ointment.jpg",
            "pharmacist.jpg",
            "capsule.jpg",
            "patient.jpg",
            "tablet.jpg",
            "pill.jpg"
        ]
        for picture in result {
            XCTAssertTrue(checkList.contains(picture.viewModel.name))
        }
    }
}
