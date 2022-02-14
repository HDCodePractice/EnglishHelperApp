//
//  GridCell.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-12.
//

import SwiftUI

struct GridCell: View {
    private let animationScaleFactor: CGFloat = 1.5
    var cell : Cell
    
    var body: some View {
        Text(cell.title)
            .font(cell.isSelected ? .title2 : .body)
            .animation(.default)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GridCell_Previews: PreviewProvider {
    static var previews: some View {
        GridCell(cell: Cell(character: "H"))
    }
}
