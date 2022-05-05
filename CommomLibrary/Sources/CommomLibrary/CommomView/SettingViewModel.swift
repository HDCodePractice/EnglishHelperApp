//
//  File.swift
//  
//
//  Created by 老房东 on 2022-05-04.
//

import Foundation
import RealmSwift
import OSLog
import Kingfisher

class SettingViewModel:ObservableObject{
    private var realmController : RealmController
    
    @Published var cacheSize = "0 MB"
    
    init(isPreview:Bool=false){
        if isPreview{
            realmController = RealmController.preview
        }else{
            realmController = RealmController.shared
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
    
    @MainActor
    func fetchData() async{
        await realmController.fetchData()
    }
    
    @MainActor
    func cleanAllNew() async{
        if let localRealm = realmController.localRealm{
            let words = localRealm.objects(Word.self).where{
                $0.isNew == true
            }
            do{
                try localRealm.write{
                    for word in words{
                        word.isNew=false
                    }
                }
            }catch{
                Logger().error("Error cleanAllNew Word to Realm:\(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func makeAllToNew() async{
        if let localRealm = realmController.localRealm{
            let words = localRealm.objects(Word.self).where{
                $0.isNew == false
            }
            do{
                try localRealm.write{
                    for word in words{
                        word.isNew=true
                    }
                }
            }catch{
                Logger().error("Error makeAllToNew Word to Realm:\(error.localizedDescription)")
            }
        }
    }
    
    func cleanRealm(){
        realmController.cleanRealm()
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
}
