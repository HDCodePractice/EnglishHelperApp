//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-09.
//
import Foundation
import CoreData

public struct PersistenceController {
    public static let shared = PersistenceController()
    
    public static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        if let chapters: [JChapter] = load("example.json",bundel: .swiftUIPreviewsCompatibleModule){
            for chapter in chapters {
                let newChapter = Chapter(context: viewContext)
                newChapter.name = chapter.name
                for topic in chapter.topics{
                    let newTopic = Topic(context: viewContext)
                    newTopic.name = topic.name
                    newChapter.addToTopics(newTopic)
                    for pic in topic.pictureFiles{
                        let newPicture = Picture(context: viewContext)
                        newPicture.name = pic.name
                        newTopic.addToPictures(newPicture)
                        for word in pic.words{
                            let newWord = Word(context: viewContext)
                            newWord.name = word
                            newPicture.addToWords(newWord)
                        }
                    }
                }
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    public let container: NSPersistentContainer
    
    public init(inMemory: Bool = false) {
        container = PersistentContainer(name: "DictionariesManager")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error.localizedDescription), \(error.userInfo)")
                return
            }
        })
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    @MainActor
    public static func fetchData(url: String, viewContext: NSManagedObjectContext) async{
        if let chapters: [JChapter] = await loadDataByServer(url: url){
            let fetchRequest: NSFetchRequest<Chapter> = Chapter.fetchRequest()
            let result = try! viewContext.fetch(fetchRequest)
            
            for chapter in result{
                viewContext.delete(chapter)
            }
            
            try! viewContext.save()
            
            for chapter in chapters {
                let newChapter = Chapter(context: viewContext)
                newChapter.name = chapter.name
                for topic in chapter.topics{
                    let newTopic = Topic(context: viewContext)
                    newTopic.name = topic.name
                    newChapter.addToTopics(newTopic)
                    for pic in topic.pictureFiles{
                        let newPicture = Picture(context: viewContext)
                        newPicture.name = pic.name
                        newTopic.addToPictures(newPicture)
                        for word in pic.words{
                            let newWord = Word(context: viewContext)
                            newWord.name = word
                            newPicture.addToWords(newWord)
                        }
                    }
                }
            }
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

class PersistentContainer: NSPersistentContainer {
    init(name: String, bundle: Bundle = .swiftUIPreviewsCompatibleModule,
         inMemory: Bool = false) {
        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Failed to create mom")
        }
        super.init(name: name, managedObjectModel: mom)
    }
}

class PersistentCloudKitContainer: NSPersistentCloudKitContainer {
    init(name: String, bundle: Bundle = .module,
         inMemory: Bool = false) {
        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Failed to create mom")
        }
        super.init(name: name, managedObjectModel: mom)
    }
}
