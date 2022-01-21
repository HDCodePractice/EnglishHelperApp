//
//  GrammarListViewModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-19.
//

import Foundation

class GrammarListViewModel: ObservableObject{
    @Published var grammars = [Grammar]()
    private let grammarsDictURl = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/grammar_dict.json"
    
    func loadData() async -> [Grammar]{
        if let g: [Grammar] = await loadDataByServer(url: grammarsDictURl) {
            return g
        }
        return []
    }
}
