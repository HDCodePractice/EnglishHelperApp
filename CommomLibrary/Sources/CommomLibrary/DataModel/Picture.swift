//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import Foundation

public struct PictureViewModel{
    let name:String
    let words: [Word]
    let topic: Topic?
}

public extension Picture{
    var viewModel: PictureViewModel {
        let wordSet = words as? Set<Word> ?? []
        return PictureViewModel(
            name: self.name ?? "Unknow",
            words: wordSet.sorted{
                $0.viewModel.name < $1.viewModel.name
            },
            topic: self.topic
        )
    }
}
