//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation

public struct TopicViewModel{
    let name:String
    let pictures: [Picture]
    let chapter: Chapter?
}

public extension Topic{
    var viewModel: TopicViewModel {
        let pictureSet = pictures as? Set<Picture> ?? []
        return TopicViewModel(
            name: self.name ?? "Unknow",
            pictures: pictureSet.sorted{
                $0.viewModel.name < $1.viewModel.name
            },
            chapter: self.chapter
        )
    }
}

struct JTopic: Codable, Identifiable {
    var id = UUID()
    var pictureFiles = [JPictureFile]()
    var name: String
    var isSelect = true
    enum CodingKeys: String, CodingKey {
        case pictureFiles
        case name
    }
}
