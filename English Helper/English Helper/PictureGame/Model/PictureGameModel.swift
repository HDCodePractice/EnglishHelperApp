//
//  PictureGameModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation
import UIKit

class PictureGameManager{
    static let instance = PictureGameManager()
    private let jsonURL = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/picture.json"
    static private let pictureBaseURL = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures"
    var chapters = [Chapter]()
    
    init(){
    }
    
    func loadData() async -> [Chapter]{
        if let d: [Chapter] = await loadDataByServer(url: jsonURL) {
            return d
        }
        return []
    }
    
    static func genPictureURL(chapter:Chapter,topic:Topic,pic:PictureFile) -> URL?{
        let imgURL = URL(string: "\(pictureBaseURL)/\(chapter.name)/\(topic.name)/\(pic.name)")
        return imgURL
    }
}
