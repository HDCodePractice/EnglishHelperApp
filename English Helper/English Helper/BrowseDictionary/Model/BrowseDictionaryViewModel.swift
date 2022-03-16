//
//  BrowseDictionaryViewModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-31.
//

import Foundation
import Kingfisher

class BrowseDictionaryViewModel: ObservableObject{
    private var manager = PictureDictionaryManager.instance
    private var realmManager = RealmManager.instance
    @Published var cacheSize = "0 MB"
    
    init(){
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
        print(cache.memoryStorage.config.expiration)
        print(cache.diskStorage.config.expiration)
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
    
    func cleanRealm(){
        realmManager.cleanRealm()
    }
    
    @MainActor
    func fromServerJsonToRealm() async{
        await manager.fromServerJsonToRealm()
    }
    
    func toggleTopic(topic: LocalTopic){
        realmManager.toggleTopic(topic: topic)
    }
    
    func toggleChapter(chapter: LocalChapter){
        realmManager.toggleChapter(chapter: chapter)
    }
    
    func getURL(pictureFile: LocalPictureFile) -> URL?{
        let filename = pictureFile.name
        let topic = pictureFile.assignee.first!.name
        let chapter = pictureFile.assignee.first!.assignee.first!.name
        return PictureDictionaryManager.genPictureURL(chapter: chapter, topic: topic, filename: filename)
    }
    
    func mokeData() -> LocalChapter?{
        return realmManager.mokeData()
    }
}
