//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation

public struct WordViewModel{
    public let name:String
    public let picture: Picture?
    public let pictureName : String
    public let topicName : String
    public let chapterName : String
    public let audioUrl : String
    public let pictureUrl : String
}

public extension Word{
    @objc
    var topicSection : String{
        let topicName = self.picture?.topic?.name ?? "Unknow"
        return topicName
    }
    
    var viewModel: WordViewModel {
        let fileName = self.name ?? ""
        let pictureName = self.picture?.name ?? ""
        let topicName = self.picture?.topic?.name ?? ""
        let chapterName = self.picture?.topic?.chapter?.name ?? ""
        
        return WordViewModel(
            name: fileName,
            picture: self.picture,
            pictureName: pictureName,
            topicName: topicName,
            chapterName: chapterName,
            audioUrl: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/audio/\(chapterName)/\(topicName)/\(fileName).wav",
            pictureUrl : "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/\(chapterName)/\(topicName)/\(pictureName)".urlEncoded()
        )
    }
}
