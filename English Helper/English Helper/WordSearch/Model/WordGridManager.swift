//
//  WordGridManager.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-14.
//

import Foundation

class WordGridManager{
    static let instance = WordGridManager()
    var words : [String] = []
    var row : Int = 0
    var column : Int = 0
    var grid : WordGrid = []
    
    init(){}
    
    func generatorWordGrid(){
        let generator = WordGridGenerator(words: words, row: row, column: column)
        if let g = generator.generate(){
            grid = []
            for row in g{
                var wordGridRow = [Cell]()
                for c in row{
                    wordGridRow.append(Cell(character: c))
                }
                grid.append(wordGridRow)
            }
        }
    }
}
