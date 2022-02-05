//
//  BrowseDictionaryViewModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-31.
//

import Foundation

class BrowseDictionaryViewModel: ObservableObject{
    private var manager = PictureDictionaryManager.instance
    private var realManager = RealmManager.instance
    
    init(){
    }
    
    func cleanRealm(){
        realManager.cleanRealm()
    }
    
    @MainActor
    func fromServerJsonToRealm() async{
        await manager.fromServerJsonToRealm()
    }
    
    func toggleTopic(topic: LocalTopic){
        realManager.toggleTopic(topic: topic)
    }
    
    func toggleChapter(chapter: LocalChapter){
        realManager.toggleChapter(chapter: chapter)
    }
    
    func getURL(pictureFile: LocalPictureFile) -> URL?{
        let filename = pictureFile.name
        let topic = pictureFile.assignee.first!.name
        let chapter = pictureFile.assignee.first!.assignee.first!.name
        return PictureDictionaryManager.genPictureURL(chapter: chapter, topic: topic, filename: filename)
    }
    
    func mokeData() -> LocalChapter?{
        return realManager.mokeData()
    }
}
