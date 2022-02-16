//
//  Line.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-12.
//

import SwiftUI

struct Position {
    var row: Int
    var col: Int
}

struct LineStyle {
    var opacity: Double
    var lineWidth: CGFloat
    var strokeColor: Color
}

struct Line: View {
    var cellSize: CGSize = .zero
    var startPos: Position
    var endPos: Position
    /// Line style
    var lineStyle: LineStyle = LineStyle(
        opacity: 0.5,
        lineWidth: 40,
        strokeColor: .green
    )
    
    /// Convert a letter at row, col to center point of the cell
    ///
    /// - Parameter pos: Position object
    /// - Returns: center point of the corresponding cell
    private func point(at pos: Position) -> CGPoint {
        return CGPoint(
            x: CGFloat(pos.col) * cellSize.width + cellSize.width / 2,
            y: CGFloat(pos.row) * cellSize.height + cellSize.height / 2)
    }
    
    var body: some View {
        Path{path in
            path.move(to: point(at: startPos))
            path.addLine(to: point(at: endPos))
        }
        .stroke(style: StrokeStyle(lineWidth: lineStyle.lineWidth, lineCap: .round))
        .foregroundColor(lineStyle.strokeColor)
        .opacity(lineStyle.opacity)
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        Line(
            cellSize: CGSize(width: 20, height: 20),
            startPos: Position(row: 0, col: 0),
            endPos: Position(row: 10, col: 10)
        )
    }
}
