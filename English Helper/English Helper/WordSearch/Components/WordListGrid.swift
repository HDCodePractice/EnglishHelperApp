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
                    cellSize: vm.getCellSize(size: proxy.size),
                    startPos: Position(row: 0, col: 0),
                    endPos: Position(row: 9, col: 9),
                    lineStyle: LineStyle(opacity: 0.5, lineWidth: vm.getCellSize(size: proxy.size).width, strokeColor: .red)
                )
                Line(
                    cellSize: vm.getCellSize(size: proxy.size),
                    startPos: Position(row: 0, col: 8),
                    endPos: Position(row: 8, col: 0),
                    lineStyle: LineStyle(opacity: 0.5, lineWidth: vm.getCellSize(size: proxy.size).width, strokeColor: .blue)
                )
                Line(
                    cellSize: vm.getCellSize(size: proxy.size),
                    startPos: Position(row: 3, col: 0),
                    endPos: Position(row: 4, col: 8),
                    lineStyle: LineStyle(opacity: 0.5, lineWidth: vm.getCellSize(size: proxy.size).width, strokeColor: .green)
                )
                if let tempLine = vm.tempLine{
                    Line(
                        cellSize: vm.getCellSize(size: proxy.size),
                        startPos: tempLine.startPosition,
                        endPos: tempLine.endPosition,
                        lineStyle: LineStyle(opacity: 0.5, lineWidth: vm.getCellSize(size: proxy.size).width, strokeColor: tempLine.color)
                    )
                }
            }
            .gesture(getGesture(size: proxy.size))
        }
    }
    
    func getGesture(size: CGSize) -> some Gesture {
        return DragGesture()
            .onChanged{ value in
                vm.drawLine(start: value.startLocation, location: value.location, size: size)
            }
    }
}

struct WordListGrid_Previews: PreviewProvider {
    static var previews: some View {
        WordListGrid()
            .environmentObject(WordSearchViewModel())
    }
}
