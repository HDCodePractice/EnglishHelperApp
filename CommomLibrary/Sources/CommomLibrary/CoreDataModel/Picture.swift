//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation

public struct PictureViewModel{
    public let name:String
    public let words: [Word]
    public let topic: Topic?
    public let path : String
}

public extension Picture{
    var viewModel: PictureViewModel {
        let wordSet = words as? Set<Word> ?? []
        return PictureViewModel(
            name: self.name ?? "Unknow",
            words: wordSet.sorted{
                $0.viewModel.name < $1.viewModel.name
            },
            topic: self.topic,
            path : {
                if let filename = self.name,
                   let topic = self.topic,
                   let topicname = topic.name,
                   let chapter = topic.chapter,
                   let chaptername = chapter.name{
                    return "\(chaptername)/\(topicname)/\(filename)"
                }else{
                    return ""
                }
            }()
        )
    }
}

struct JPictureFile: Codable {
    var name: String
    var words = [String]()
}
