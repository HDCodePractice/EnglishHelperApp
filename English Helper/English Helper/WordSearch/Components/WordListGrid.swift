//
//  WordListGrid.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-12.
//

import SwiftUI

struct WordListGrid: View {
    @EnvironmentObject var vm : WordSearchViewModel
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                VStack{
                    ForEach (vm.grid,id:\.self){ row in
                        HStack{
                            ForEach (row){ c in
                                GridCell(cell: c)
                                    .onTapGesture {
                                        vm.toggleGridCell(cell: c)
                                    }
                            }
                        }
                    }
                }
                Line(
                    cellSize: CGSize(width: proxy.size.width/10, height: proxy.size.height/10),
                    startPos: Position(row: 0, col: 0),
                    endPos: Position(row: 9, col: 9)
                )
                Line(
                    cellSize: CGSize(width: proxy.size.width/10, height: proxy.size.height/10),
                    startPos: Position(row: 0, col: 8),
                    endPos: Position(row: 8, col: 0)
                )
            }
        }
    }
}

struct WordListGrid_Previews: PreviewProvider {
    static var previews: some View {
        WordListGrid()
            .environmentObject(WordSearchViewModel())
    }
}
