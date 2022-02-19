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
    private var selectWord : String = ""
    
    init(){}
    
    func getWordsCells() -> [WordCell]{
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
    
    func getWordByPosition(start: Position,end: Position) -> String{
        if canAttempt(startPosition: start, endPos: end){
            if end.row >= grid.count || end.col >= grid[0].count { return selectWord }
            if start.row >= grid.count || start.col >= grid[0].count { return selectWord }
            let rowProgressive = start.row>end.row ? -1 : start.row<end.row ? 1 : 0
            let colProgressive = start.col>end.col ? -1 : start.col<end.col ? 1 : 0
            var nowPosition = start
            var word : String = String(grid[nowPosition.row][nowPosition.col].character)
            while nowPosition != end{
                nowPosition.col += colProgressive
                nowPosition.row += rowProgressive
                word.append(grid[nowPosition.row][nowPosition.col].character)
            }
            selectWord = word
        }
        return selectWord
    }
    
    
    func generatorWordGrid(){
        let generator = WordSearchGenerator(words: titles, row: row, column: column)
        generator.difficulty = .hard
        generator.makeGrid()
        grid = generator.cells
        wordsMap = generator.wordsMap
        words = []
        for word in generator.words{
            words.append(word.title)
        }
        wordCells = generator.words
    }
    
    /// Check if start position and end position are horizontal
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: they are horizontal
    private func isHorizontal(startPosition: Position,with endPos: Position) -> Bool {
        return startPosition.row == endPos.row
    }


    /// Check if start position and end position are vertical
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: they are vertical
    private func isVertical(startPosition: Position,with endPos: Position) -> Bool {
        return startPosition.col == endPos.col
    }

    /// Check if start position and end position are diagonal
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: they are diagonal
    private func isDiagonal(startPosition: Position,with endPos: Position) -> Bool {
        return abs(startPosition.row - endPos.row) == abs(startPosition.col - endPos.col)
    }


    /// Check if target end position is a valid one that is horizontal,
    /// vertical or diagonal with the start position. If valid, update the current
    /// end position
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: if the end position is valid or not
    func canAttempt(startPosition: Position,endPos: Position) -> Bool {
        if isHorizontal(startPosition: startPosition,with: endPos) ||
            isVertical(startPosition: startPosition,with: endPos) ||
            isDiagonal(startPosition: startPosition,with: endPos) {
            return true
        }
        return false
    }
}
