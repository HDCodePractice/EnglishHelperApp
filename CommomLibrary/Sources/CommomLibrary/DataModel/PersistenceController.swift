//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-09.
//
import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0...3 {
            let newItem = Chapter(context: viewContext)
            newItem.name = "Chapter \(i)"
            for j in 1...3{
                let newTopic = Topic(context: viewContext)
                newTopic.name = "Chapter \(i) Topic \(j)"
                newItem.addToTopics(newTopic)
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
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
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
}

class PersistentContainer: NSPersistentContainer {
    init(name: String, bundle: Bundle = .module,
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