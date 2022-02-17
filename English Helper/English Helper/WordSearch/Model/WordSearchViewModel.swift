//
//  WordSearchViewModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-12.
//

import Foundation
import SwiftUI

class WordSearchViewModel:ObservableObject{
    private let manager = WordGridManager.instance
    @Published var grid : WordGrid = []
    @Published var row : Int = 10
    @Published var column : Int = 10
    @Published var words : [WordCell] = []
    @Published var lines : [DrawLine] = []
    @Published var tempLine : DrawLine?
        
    init(){
        manager.words = ["hello","world","search","words"]
        manager.row = row
        manager.column = column
        manager.generatorWordGrid()
        grid = manager.grid
        words = manager.getWordsCells()
    }
    
    func toggleGridCell(cell: Cell){
        grid[cell.row][cell.column].isSelected.toggle()
    }
    
    func getCellSize(size: CGSize) -> CGSize{
        return CGSize(width: size.width/CGFloat(row), height: size.height/CGFloat(column))
    }
    
    func drawLine(start: CGPoint, location: CGPoint, size: CGSize){
        let startCol = Int(start.x/(size.width/CGFloat(row)))
        let startRow = Int(start.y/(size.height/CGFloat(column)))
        
        let endCol = Int(location.x/(size.width/CGFloat(row)))
        let endRow = Int(location.y/(size.height/CGFloat(column)))
        tempLine = DrawLine(
                startPosition: Position(row: startRow, col: startCol),
                endPosition: Position(row: endRow, col: endCol),
                color: .red)
    }
}
