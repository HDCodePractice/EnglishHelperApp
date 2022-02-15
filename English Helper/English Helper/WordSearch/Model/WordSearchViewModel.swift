//
//  WordSearchViewModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-12.
//

import Foundation

class WordSearchViewModel:ObservableObject{
    private let manager = WordGridManager.instance
    @Published var grid : WordGrid = []
    @Published var row : Int = 10
    @Published var column : Int = 10
    @Published var words : [WordCell] = []
    
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
}
