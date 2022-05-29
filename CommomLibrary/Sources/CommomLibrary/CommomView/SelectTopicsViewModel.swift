//
//  File.swift
//  
//
//  Created by 老房东 on 2022-04-25.
//

import Foundation
import Kingfisher
import RealmSwift
import OSLog

class SelectTopicsViewModel: ObservableObject{
    private var realmController : RealmController
    
    @Published var cacheSize = "0 MB"
    
    var realmFilePath : String{
        return realmController.realmFilePath
    }
    
    init(isPreview:Bool=false){
        if isPreview{
            self.realmController = RealmController.preview
        }else{
            self.realmController = RealmController.shared
        }
        
        let cache = ImageCache.default
        cache.calculateDiskStorageSize { result in
            switch result{
            case .success(let size):
                self.cacheSize = "\(Int(Double(size) / 1024 / 1024)) MB"
            case .failure(let error):
                self.cacheSize = "\(error)"
            }
        }
    }
    
    func cleanCache(){
        let cache = ImageCache.default
        //        print(cache.memoryStorage.config.expiration)
        //        print(cache.diskStorage.config.expiration)
        cache.clearCache()
        cache.calculateDiskStorageSize { result in
            switch result{
            case .success(let size):
                self.cacheSize = "\(Int(Double(size) / 1024 / 1024)) MB"
            case .failure(let error):
                self.cacheSize = "\(error)"
            }
        }
    }
    
    @MainActor
    func fetchData() async{
        await realmController.fetchData()
    }
    
    func toggleTopic(topic: Topic){
        topic.toggleSelect(isChangeChapter: true)
    }
    
    func toggleChapter(chapter: Chapter){
        chapter.toggleSelect(isChangeTopics: true)
    }
}
