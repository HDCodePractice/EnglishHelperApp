//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation

public struct ChapterViewModel{
    let name:String
    let topics: [Topic]
}

public extension Chapter{
    var viewModel: ChapterViewModel {
        let topicSet = topics as? Set<Topic> ?? []
        return ChapterViewModel(
            name: self.name ?? "Unknow",
            topics: topicSet.sorted{
                $0.viewModel.name < $1.viewModel.name
            }
        )
    }
}

struct JChapter: Codable,Identifiable {
    public var id = UUID()
    var name: String
    var topics = [JTopic]()
    var isSelect = true
    enum CodingKeys: String, CodingKey {
        case topics
        case name
    }
}
