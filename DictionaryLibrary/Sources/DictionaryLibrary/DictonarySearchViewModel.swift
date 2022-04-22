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
    
    @Published var filteredTopics = [String]()
    
    init(isPreview:Bool=false){
        if isPreview{
            realmController = RealmController.preview
        }else{
            realmController = RealmController.shared
        }
    }
    
    @MainActor
    func fetchData() async{
        await realmController.fetchData()
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

