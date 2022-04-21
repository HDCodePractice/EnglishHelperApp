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
    
    private let jsonURL = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"
    
    func fetchData() async{
        // await PersistenceController.fetchData(url: jsonURL, viewContext: viewContext)
    }
}

