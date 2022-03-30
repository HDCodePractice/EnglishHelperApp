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
    public let topicName : String
    public let chapterName : String
    public let pictureUrl : String
}

public extension Picture{
    var viewModel: PictureViewModel {
        let wordSet = words as? Set<Word> ?? []
        let topicName = self.topic?.name ?? ""
        let chapterName = self.topic?.chapter?.name ?? ""
        let filename = self.name ?? "Unknow"
        return PictureViewModel(
            name: filename,
            words: wordSet.sorted{
                $0.viewModel.name < $1.viewModel.name
            },
            topic: self.topic,
            topicName: topicName,
            chapterName: chapterName,
            pictureUrl : "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/\(chapterName)/\(topicName)/\(filename)".urlEncoded()
        )
    }
}

struct JPictureFile: Codable {
    var name: String
    var words = [String]()
}
