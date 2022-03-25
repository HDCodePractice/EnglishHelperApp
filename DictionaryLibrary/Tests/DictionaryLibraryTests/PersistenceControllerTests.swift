//
//  PersistenceControllerTests.swift
//  
//
//  Created by 老房东 on 2022-03-19.
//
import XCTest
import CoreData
@testable import CommomLibrary

class PersistenceControllerTests: XCTestCase {
    var viewContext : NSManagedObjectContext?
    
    override func setUpWithError() throws {
        let result = PersistenceController(inMemory: true)
        viewContext = result.container.viewContext
        
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        
        for i in 0...3 {
            let newChapter = Chapter(context: viewContext)
            newChapter.name = "Chapter\(i)"
            for j in 0...3{
                let newTopic = Topic(context: viewContext)
                newTopic.name = "Chapter\(i) Topic\(j)"
                newChapter.addToTopics(newTopic)
                for k in 0...3{
                    let newPicture = Picture(context: viewContext)
                    newPicture.name = "Chapter\(i) Topic\(j) Picture\(k)"
                    newTopic.addToPictures(newPicture)
                    for l in 0...3{
                        let newWord = Word(context: viewContext)
                        newWord.name = "Chapter\(i) Topic\(j) Picture\(k) Word\(l)"
                        newPicture.addToWords(newWord)
                    }
                }
            }
        }
        try! viewContext.save()
    }

    override func tearDownWithError() throws {
        viewContext = nil
    }

    func testInitChapternameAndCountTopics() throws {
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        // Given
        
        // When
        let fetchRequest: NSFetchRequest<Chapter> = Chapter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", "Chapter0")
        let result = try? viewContext.fetch(fetchRequest)
        let finalChapter1 = result?.first
        
        //Then
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(finalChapter1?.name, "Chapter0")
        XCTAssertEqual(finalChapter1?.topics?.count, 4)
    }
    
    func testCountChapter() throws{
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        
        // When
        let fetchRequest: NSFetchRequest<Chapter> = Chapter.fetchRequest()
        var count = 0
        viewContext.performAndWait {
            count = try! viewContext.count(for: fetchRequest)
        }
        
        // Then
        XCTAssertEqual(count, 4)
    }

    func testCountTopic() throws{
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        
        // When
        let fetchRequest: NSFetchRequest<Topic> = Topic.fetchRequest()
        var count = 0
        viewContext.performAndWait {
            count = try! viewContext.count(for: fetchRequest)
        }
        
        // Then
        XCTAssertEqual(count, 16)
    }
    
    func testCountPicture() throws{
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        
        // When
        let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
        var count = 0
        viewContext.performAndWait {
            count = try! viewContext.count(for: fetchRequest)
        }
        
        // Then
        XCTAssertEqual(count, 16*4)
    }
    
    func testCountWord() throws{
        guard let viewContext = viewContext else {
            XCTAssertTrue(false)
            return
        }
        
        // When
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        var count = 0
        viewContext.performAndWait {
            count = try! viewContext.count(for: fetchRequest)
        }
        
        // Then
        XCTAssertEqual(count, 16*4*4)
    }
}
