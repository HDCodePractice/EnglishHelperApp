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
                .lineLimit(1)
                .minimumScaleFactor(0.01)
                .padding(5)
                .background(wordCell.color)
                .opacity(0.5)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 5)
                )
        }else{
            Text(wordCell.title)
                .lineLimit(1)
                .minimumScaleFactor(0.01)
                .padding(10)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 5)
                )
            
        }
        
    }
}

struct WordCellView_Previews: PreviewProvider {
    static var previews: some View {
        WordCellView(wordCell: WordCell(title: "hello"))
        WordCellView(wordCell: WordCell(title: "hello",isSelected: true))
    }
}
