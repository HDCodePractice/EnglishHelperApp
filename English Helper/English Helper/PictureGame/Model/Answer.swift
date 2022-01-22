//
//  Answer.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import Foundation

struct Answer: Identifiable{
    var id = UUID()
    var name : String
    var isCorrect : Bool
    var url : URL?
}
