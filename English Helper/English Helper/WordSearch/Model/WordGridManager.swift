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
    var wordsMap: [String: String] = [:]
    var row : Int = 0
    var column : Int = 0
    var grid : WordGrid = []
    var g : Grid = []
    
    init(){}
    
    func getWordsCells() -> [WordCell]{
        var wordCells:[WordCell] = []
        for word in words{
            wordCells.append(WordCell(word: word))
        }
        return wordCells
    }
    
    func checkWordByPosition(start: Position,end: Position) -> String?{
        // "startRow:startCol:endRow:endCol"
        let path = "\(start.row):\(start.col):\(end.row):\(end.col)"
        if let word = wordsMap[path] {
            return word
        }
        return nil
    }
    
    func generatorWordGrid(){
        let generator = WordGridGenerator(words: words, row: row, column: column)
        if let g = generator.generate(){
            self.g = g
            grid = []
            for r in 0..<g.count{
                var wordGridRow = [Cell]()
                for c in 0..<g[r].count{
                    wordGridRow.append(Cell(character: g[r][c],row: r,column: c))
                }
                grid.append(wordGridRow)
            }
            wordsMap = generator.wordsMap
        }
    }
}
