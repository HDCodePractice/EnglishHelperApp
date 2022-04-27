//
//  File.swift
//  
//
//  Created by Lei Zhou on 3/6/22.
//

import SwiftUI
import CommomLibrary
import RealmSwift

class PictureGameViewModel: ObservableObject{
    private var realmController : RealmController
    
    @Published var gameStatus : GameStatus = .start
    @AppStorage(UserDefaults.UserDefaultsKeys.isAutoPronounce.rawValue) var isAutoPronounce = true
    @Published var gameMode = GameMode.uniq
    @Published var length = 10
    
    @Published private(set) var index = 0
    @Published private(set) var score = 0
    @Published private(set) var reachedEnd = false

    
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
    
    func cleanRealm(){
        realmController.cleanRealm()
    }
    
    func generatePictureExam(){
        guard let localRealm = realmController.localRealm , let memoRealm = realmController.memoRealm else{
            return
        }
        
        var memoRealmWordCount = 0
        let chapters = localRealm.objects(Chapter.self).where{
            $0.isSelect == true
        }
        
        try! memoRealm.write{
            memoRealm.deleteAll()
            for chapter in chapters{
                memoRealm.create(Chapter.self, value: chapter)
            }
            
            let noSelectWords = memoRealm.objects(Word.self).where { word in
                word.assignee.assignee.isSelect == false
            }
            memoRealm.delete(noSelectWords)
            
            let noSelectPictureFiles = memoRealm.objects(Picture.self).where{
                $0.assignee.isSelect == false
            }
            memoRealm.delete(noSelectPictureFiles)
            
            let noSelectTopics = memoRealm.objects(Topic.self).where{
                $0.isSelect == false
            }
            memoRealm.delete(noSelectTopics)
        }
        memoRealmWordCount = memoRealm.objects(Word.self).count
        
        switch gameMode {
        case .uniq:
            if memoRealmWordCount < length{
                length = memoRealmWordCount
            }
        case .random:
            // 不做任何事
            length = length
        case .finish:
            length = memoRealmWordCount
        }
        
        if length == 0 {
            return
        }
        reachedEnd = false
        index = 0
        score = 0
        
//        setQuestion()
        gameStatus = .inProgress
    }
}

enum GameMode: String, CaseIterable {
    case uniq = "Uniq"
    case random = "Random"
    case finish = "Finish"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
