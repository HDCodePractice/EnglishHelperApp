//
//  DrawLine.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-16.
//

import Foundation
import SwiftUI

struct DrawLine: Identifiable{
    var id = UUID()
    var startPosition : Position
    var endPosition : Position
    var color : Color
    
    /// Check if start position and end position are horizontal
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: they are horizontal
    private func isHorizontal(with endPos: Position) -> Bool {
        return startPosition.row == endPos.row
    }


    /// Check if start position and end position are vertical
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: they are vertical
    private func isVertical(with endPos: Position) -> Bool {
        return startPosition.col == endPos.col
    }

    /// Check if start position and end position are diagonal
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: they are diagonal
    private func isDiagonal(with endPos: Position) -> Bool {
        return abs(startPosition.row - endPos.row) == abs(startPosition.col - endPos.col)
    }


    /// Check if target end position is a valid one that is horizontal,
    /// vertical or diagonal with the start position. If valid, update the current
    /// end position
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: if the end position is valid or not
    mutating func attempt(endPos: Position) -> Bool {
        if isHorizontal(with: endPos) ||
            isVertical(with: endPos) ||
            isDiagonal(with: endPos) {
            endPosition = endPos
            return true
        }
        return false
    }
}
