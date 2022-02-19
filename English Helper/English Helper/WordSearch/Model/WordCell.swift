//
//  WordCell.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-15.
//

import Foundation
import SwiftUI

struct WordCell: Hashable, Identifiable {
    var id : UUID = UUID()
    var title : String
    var isSelected : Bool = false
    var color : Color = .clear
    var word : String {
        return title.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "'", with: "")
    }
}
