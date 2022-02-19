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
            Text(wordCell.title)
                .strikethrough()
                .italic()
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.01)
                .background(wordCell.color)
                .opacity(0.5)
                .cornerRadius(20)
        }else{
            Text(wordCell.title)
                .lineLimit(1)
                .minimumScaleFactor(0.01)
                .foregroundColor(.primary)
        }
        
    }
}

struct WordCellView_Previews: PreviewProvider {
    static var previews: some View {
        WordCellView(wordCell: WordCell(title: "hello"))
        WordCellView(wordCell: WordCell(title: "hello",isSelected: true))
    }
}
