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
    private var realmController : RealmController
    private let jsonURL = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"

    @Published var filteredTopics = [String]()
    
    init(isPreview:Bool=false){
        if isPreview{
            realmController = RealmController.preview
        }else{
            realmController = RealmController.shared
        }
    }
    
    
    func fetchData() async{
        // await PersistenceController.fetchData(url: jsonURL, viewContext: viewContext)
    }
    
    func setFilteredTopicList(searchFilter: String){
        if searchFilter.isEmpty{
            return
        }
        if let localRealm = realmController.localRealm{
            let topics = localRealm.objects(Topic.self).where{
                $0.pictures.words.name.contains(searchFilter, options: .caseInsensitive)
            }
            if topics.isEmpty{
                return
            }
            filteredTopics = []
            for topic in topics{
                filteredTopics.append(topic.name)
            }
        }
    }
}

