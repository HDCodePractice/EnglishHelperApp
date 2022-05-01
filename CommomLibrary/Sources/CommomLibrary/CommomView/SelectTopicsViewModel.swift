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

    func cleanRealm(){
        realmController.cleanRealm()
    }
    
    func toggleTopic(topic: Topic){
        if let localRealm = realmController.localRealm {
            do{
                if let topic = topic.thaw() , let chapter = topic.assignee.first{
                    try localRealm.write{
                        topic.isSelect.toggle()
                        // 如果chapter没选，顺便选上
                        if topic.isSelect && !chapter.isSelect{
                            chapter.isSelect = true
                            return
                        }
                        // 如果chapter选上了，查看是不是所有的都是没选中的，如果都没选，chapter也取消选择
                        if chapter.isSelect{
                            for t in chapter.topics{
                                if t.isSelect{
                                    return
                                }
                            }
                            // 所有子项都没选择，把chapter也取消选择
                            chapter.isSelect = false
                        }
                    }
                }
            }catch{
                Logger().error("toggle topict \(topic.name) error:\(error.localizedDescription)")
            }
        }
    }
    
    func toggleChapter(chapter: Chapter){
        if let localRealm = realmController.localRealm {
            do{
                if let chapter = chapter.thaw(){
                    try localRealm.write{
                        chapter.isSelect.toggle()
                        for topic in chapter.topics{
                            if topic.isSelect != chapter.isSelect {
                                topic.isSelect = chapter.isSelect
                            }
                        }
                    }
                }
            }catch{
                Logger().error("toggle chapter \(chapter.name) error: \(error.localizedDescription)")
            }
        }
    }
}
