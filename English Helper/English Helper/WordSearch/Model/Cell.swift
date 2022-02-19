//
//  GridCell.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-14.
//

import Foundation

typealias WordGrid = [[Cell]]

class Cell: Hashable,Identifiable {
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(character: Character = "#",row: Int = 0 ,column: Int = 0){
        self.character = character
        self.row = row
        self.column = column
    }
    
    var id : UUID = UUID()
    var character : Character = "#"
    var row : Int = 0
    var column : Int = 0
    var title : String {
        return String(character)
    }
    var isSelected : Bool = false
}
