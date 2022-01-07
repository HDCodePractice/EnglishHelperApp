//
//  File.swift
//  
//
//  Created by 老房东 on 2022-01-04.
//

import Foundation

struct Picture: Identifiable,Codable {
    var id = UUID()
    var chapter: String
    var filename: String
    var name: String
    var topic: String
    var words : [PictureWord]
    
    enum CodingKeys: String, CodingKey{
        case chapter
        case filename
        case name
        case topic
        case words
    }
}

struct PictureWord: Identifiable,Codable {
    var id = UUID()
    var index: String
    var name: String
    
    enum CodingKeys: String, CodingKey{
        case index
        case name
    }
}
