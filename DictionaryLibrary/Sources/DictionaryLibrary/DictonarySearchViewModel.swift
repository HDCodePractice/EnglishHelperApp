//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-26.
//

import Foundation
import CoreData
import CommomLibrary
import RealmSwift
import OSLog

class DictonarySearchViewModel: ObservableObject{
    private var realmController : RealmController
    
    @Published var isOnlyShowNewWord = false
    
    var isNewWords : Int {
        if let localRealm = realmController.localRealm{
            let count = localRealm.objects(Word.self).where{
                $0.isNew == true
            }.count
            return count
        }
        return 0
    }
        
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
}

