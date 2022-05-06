//
//  Answer.swift
//  
//
//  Created by Lei Zhou on 3/6/22.
//

import Foundation

struct Answer: Identifiable {
    var id: UUID = UUID()
    var name : String
    var isSelected: Bool = false
    var isCorrect: Bool
    var picUrl: String
    var filePath : String
}
