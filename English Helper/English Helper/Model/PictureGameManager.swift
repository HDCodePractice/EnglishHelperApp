//
//  PictureGameModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation
import RealmSwift

class PictureDictionaryManager{
    static let instance = PictureDictionaryManager()
    let jsonURL = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"
    static private let pictureBaseURL = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures"
    var chapters = [Chapter]()
    
    private(set) var realmManager = RealmManager.instance
    private(set) var topics: [LocalTopic] = []
    
    init(){
    }
    
    @MainActor
    func fromServerJsonToRealm() async{
        await loadData()
        if chapters.count > 0{
            realmManager.syncFromServer(chapters: chapters)
        }
    }
    
    static func genPictureURL(chapter:String,topic:String,filename:String) -> URL?{
        let imgURL = URL(string: "\(pictureBaseURL)/\(chapter)/\(topic)/\(filename)".urlEncoded())
        return imgURL
    }
    
    func loadData() async{
        if let d: [Chapter] = await loadDataByServer(url: jsonURL){
            chapters = d
        }else{
            chapters = []
        }
    }
}
