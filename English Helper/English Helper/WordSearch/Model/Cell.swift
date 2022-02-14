//
//  GridCell.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-14.
//

import Foundation

typealias WordGrid = [[Cell]]

struct Cell: Hashable, Identifiable {
    var id : UUID = UUID()
    var character : Character = "#"
    var title : String {
        return String(character)
    }
    var isSelected : Bool = false
}
