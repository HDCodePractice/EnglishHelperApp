//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-26.
//

import Foundation
import CoreData
import CommomLibrary

class DictonarySearchViewModel: ObservableObject{
    @Published var searchText : String = ""
    @Published var loadStatue : LoadStatue = .load
    
    private let jsonURL = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"
    
    func fetchData(viewContext: NSManagedObjectContext){
        Task{
            await PersistenceController.fetchData(url: jsonURL, viewContext: viewContext)
            self.loadStatue = .finish
        }
    }
}

enum LoadStatue{
    case load
    case finish
}
