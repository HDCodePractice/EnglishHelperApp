//
//  Topic.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation

struct Topic: Codable, Identifiable {
    var id = UUID()
    var pictureFiles = [PictureFile]()
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case pictureFiles
        case name
    }
}
