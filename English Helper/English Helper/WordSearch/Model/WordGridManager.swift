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
    var titles : [String] = []
    var wordsMap: [String: String] = [:]
    var row : Int = 0
    var column : Int = 0
    var grid : WordGrid = []
    var g : [[Character]] = []
    
    init(){}
    
    func getWordsCells() -> [WordCell]{
        var wordCells:[WordCell] = []
        words = []
        for word in titles{
            let wordCell = WordCell(title: word)
            wordCells.append(wordCell)
            words.append(wordCell.word)
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
        let generator = WordSearchGenerator(words: words, row: row, column: column)
        generator.makeGrid()
        grid = generator.cells
        wordsMap = generator.wordsMap
        words = []
        for word in generator.words{
            words.append(word.title)
        }
    }
}
