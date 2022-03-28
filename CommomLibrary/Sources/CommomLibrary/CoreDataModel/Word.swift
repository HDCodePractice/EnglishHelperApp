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
    public let audioUrl : String
}

public extension Word{
    var viewModel: WordViewModel {
        return WordViewModel(
            name: self.name ?? "Unknow",
            picture: self.picture,
            audioUrl: {
                if let filename = self.name,
                   let picture = self.picture,
                   let topic = picture.topic,
                   let topicname = topic.name,
                   let chapter = topic.chapter,
                   let chaptername = chapter.name{
                    return "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/audio/\(chaptername)/\(topicname)/\(filename).wav"
                }else{
                    return ""
                }
            }()
        )
    }
}
