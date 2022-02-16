//
//  WordCell.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-14.
//

import SwiftUI

struct WordCellView: View {
    private let animationScaleFactor: CGFloat = 1.5
    var wordCell : WordCell
    
    var body: some View {
        if wordCell.isSelected{
            Text(wordCell.word)
                .strikethrough()
                .italic()
                .foregroundColor(.secondary)
        }else{
            Text(wordCell.word)
                .foregroundColor(.primary)
        }
        
    }
}

struct WordCellView_Previews: PreviewProvider {
    static var previews: some View {
        WordCellView(wordCell: WordCell(word: "hello"))
        WordCellView(wordCell: WordCell(word: "hello",isSelected: true))
    }
}
