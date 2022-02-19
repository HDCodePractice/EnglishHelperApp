//
//  WordGridGenerator2.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-18.
//  参考自 https://github.com/Subhanc/Word-Search/blob/master/Shopify%20Fall%202019%20Challenge/Model/WordSearch.swift
//

import Foundation

enum PlacementType: CaseIterable {
case leftRight
case rightLeft
case upDown
case downUP
case topLeftBottomRight
case topRightBottomLeft
case bottomLeftTopRight
case bottomRightTopLeft
    
    var movement: (x: Int, y:Int){
        switch self{
        case .leftRight:
            return (1,0)
        case .rightLeft:
            return (-1,0)
        case .upDown:
            return (0,1)
        case .downUP:
            return(0,-1)
        case .topLeftBottomRight:
            return(1,1)
        case .topRightBottomLeft:
            return(-1,1)
        case .bottomLeftTopRight:
            return(1,-1)
        case .bottomRightTopLeft:
            return(-1,-1)
        }
    }
}


enum Difficulty{
    case easy
    case medium
    case hard
    
    var placementTypes : [PlacementType]{
        switch self{
        case .easy:
            return [.leftRight, .upDown].shuffled()
        case .medium:
            return [.leftRight,.rightLeft,.upDown,.downUP].shuffled()
        case .hard:
            return PlacementType.allCases.shuffled()
        }
    }
}


class WordSearchGenerator {
    var words = [WordCell]()
    var nRow = 10
    var nColumn = 10
    
    var cells = [[Cell]]()
    var difficulty = Difficulty.easy
    var wordsMap: [String: String] = [:]
    
    let allLetters = (65...90).map { Character(Unicode.Scalar($0)) }
    
    init(words: [String], row: Int, column: Int){
        for word in words{
            self.words.append(WordCell(title: word))
        }
        nRow = row
        nColumn = column
    }
    
    func makeGrid(){
        cells = (0..<nRow).map { row in
            (0..<nColumn).map { col in
                Cell(row: row, column: col)
            }
        }
        words = placeWords()
        fillGaps()
    }
    
    private func fillGaps(){
        for row in cells{
            for cell in row{
                if cell.character == "#" {
                    cell.character = allLetters.randomElement()!
                }
            }
        }
    }
    
    func printGrid(){
        for word in words{
            print(word.title, terminator: " /")
        }
        print("")
        print(wordsMap)
        for row in cells{
            for cell in row{
                print(cell.title, terminator: "")
            }
            print("")
        }
    }
    
    /**
     Places the words in the grid
     - Returns: the word array that were placed
     */
    func placeWords() -> [WordCell] {
        words.shuffle()
        
        var usedWords = [WordCell]()
        
        for word in words {
            if isPlace(word.word) {
                usedWords.append(word)
            }
        }
        return usedWords
    }
    
    /**
     Checks to see if word can be placed in any direction within the difficulty placementTypes
     - Parameter word: word item to be placed
     - Returns: true if word is able to be placed
     */
    func isPlace(_ word: String) -> Bool {
        for type in difficulty.placementTypes {
            if (didPlace(word, withMovement: type.movement)) {
                return true
            }
        }
        return false
    }
    
    /**
     Checks if a word can be placed in given movement unit vector direction
     - Parameters:
         - word: word item to be placed
         - movement: Tuple that indicates direction of word to be placed
     - Returns: true if word was correctly placed
     */
    func didPlace(_ word: String, withMovement movement: (x: Int, y: Int)) -> Bool {
        
        let xLength = movement.x * (word.count - 1)
        let yLength = movement.y * (word.count - 1)
        
        let rows = (0 ..< nRow).shuffled()
        let cols = (0 ..< nColumn).shuffled()
        
        for row in rows {
            for col in cols {
                let finalX = col + xLength
                let finalY = row + yLength
                
                if (finalX >= 0 && finalX < nColumn && finalY >= 0 && finalY < nRow) {
                    if let returnArray = getAvailableLabels(x: col, y: row, for: word, withMovement: movement) {
                        for (index, letter) in word.enumerated() {
                            returnArray[index].character = letter
                        }
                        wordsMap["\(col):\(row):\(finalX):\(finalY)"] = word
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /**
     Returns label location for which the word is to be placed
     - Parameters:
         - x: start x position
         - y: start y position
         - word: word to be placed
         - movement: Tuple for x and y unit vectors
     - Returns: Array of labels locations
     */
    func getAvailableLabels(x: Int, y: Int, for word: String, withMovement movement: (x: Int, y: Int)) -> [Cell]? {
        
        var returnArray = [Cell]()
        
        var xPosition = x;
        var yPosition = y;
        
        for letter in word {
            let label = cells[xPosition][yPosition]
            
            // If location can be used as part of our word
            if label.character == "#" || label.character == letter {
                returnArray.append(label)
                xPosition += movement.x
                yPosition += movement.y
            } else {
                // Cannot be used
                return nil
            }
        }
        return returnArray
    }
}
