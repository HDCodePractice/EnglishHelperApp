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
    var wordCells : [WordCell] = []
    var titles : [String] = []
    var wordsMap: [String: String] = [:]
    var row : Int = 10
    var column : Int = 10
    var grid : WordGrid = []
    var g : [[Character]] = []
    
    init(){}
    
    func getWordsCells() -> [WordCell]{
        return wordCells
    }
    
    func checkWordByPosition(start: Position,end: Position) -> String?{
        // "startRow:startCol:endRow:endCol"
        let path = "\(start.row):\(start.col):\(end.row):\(end.col)"
        print(path)
        if let word = wordsMap[path] {
            return word
        }
        return nil
    }
    
    func generatorWordGrid(){
        let generator = WordSearchGenerator(words: titles, row: row, column: column)
        generator.makeGrid()
        grid = generator.cells
        wordsMap = generator.wordsMap
        words = []
        for word in generator.words{
            words.append(word.title)
        }
        wordCells = generator.words
    }
}
