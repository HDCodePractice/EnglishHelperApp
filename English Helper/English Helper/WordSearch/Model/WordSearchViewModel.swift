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
    @Published var words : [String] = ["hello","world"]
    
    init(){
        manager.words = words
        manager.row = row
        manager.column = column
        manager.generatorWordGrid()
        grid = manager.grid
    }
    
}
