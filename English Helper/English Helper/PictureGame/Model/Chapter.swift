//
//  Chapter.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation

struct Chapter: Codable,Identifiable {
    var id = UUID()
    var name: String
    var topics = [Topic]()
    enum CodingKeys: String, CodingKey {
        case topics
        case name
    }
}
