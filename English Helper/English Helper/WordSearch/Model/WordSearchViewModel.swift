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
    private var realmManager = RealmManager.instance
    
    @Published var grid : WordGrid = []
    @Published var row : Int = 10
    @Published var column : Int = 10
    @Published var words : [WordCell] = []
    @Published var lines : [DrawLine] = []
    @Published var tempLine : DrawLine?
    let colors : [Color] = [.red,.blue,.green,.yellow,.pink,.mint,.purple,.gray]
    
    init(){}
    
    func startGame(){
        manager.titles = realmManager.genWords(lenght: 4)
        print("titles: \(manager.titles)")
        manager.row = row
        manager.column = column
        words = manager.getWordsCells()
        
        manager.generatorWordGrid()
        grid = manager.grid
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
        
        let startPos = Position(row: startRow, col: startCol)
        let endPos = Position(row: endRow, col: endCol)
        
        if tempLine == nil {
            tempLine = DrawLine(
                startPosition: startPos,
                endPosition: endPos,
                color: .yellow)
        }else{
            let _ = tempLine?.attempt(endPos: endPos)
        }
        
        if let word = manager.checkWordByPosition(start: startPos, end: endPos), let tempLine=tempLine{
            if !lines.contains(where: { $0.id == tempLine.id }){
                lines.append(tempLine)
                lines[lines.count - 1].color = colors[lines.count - 1]
            }
            if let index = words.firstIndex(where: {$0.word == word}){
                words[index].isSelected = true
                words[index].color = colors[lines.count - 1]
            }
        }
    }
    
    func finishLine(start: CGPoint, location: CGPoint, size: CGSize){
        drawLine(start: start, location: location, size: size)
    }
}
