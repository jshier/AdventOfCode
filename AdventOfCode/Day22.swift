//
//  Day22.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/22/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day22: Day {
    override func perform() {
//        let fileInput = String.input(forDay: 22)
        let testInput = """
                        ..#
                        #..
                        ...
                        """
        let input = testInput
        let grid = Grid(content: input)
        print(grid)
    }
    
    
}

struct Grid {
    let content: [[Node]]
    
    init(content: String) {
        let lines = content.split(separator: "\n")
        self.content = lines.map { $0.flatMap { Node(rawValue: $0) } }
        assert(self.content.count == self.content[0].count)
    }
    
    subscript(point: Point) -> Node {
        return content[point.y][point.x]
    }
}

extension Grid: CustomStringConvertible {
    var description: String {
        let lines = content.map { $0.map { String($0.rawValue) }.joined() }
        return lines.joined(separator: "\n")
    }
}

enum Node: Character {
    case clean = "."
    case infected = "#"
}

extension Node: CustomStringConvertible {
    var description: String {
        return String(rawValue)
    }
}

typealias Point = (x: Int, y: Int)

//struct Point {
//    let x: Int
//    let y: Int
//
//    init(_ x: Int, _ y: Int) {
//        self.x = x
//        self.y = y
//    }
//}

struct Virus {
    let position: Point
    let direction: Direction
}

enum Direction {
    case up, down, left, right
    
    var forwardOffset: (Int, Int) {
        switch self {
        case .up: return (0, 1)
        case .down: return (0, -1)
        case .left: return (-1, 0)
        case .right: return (1, 0)
        }
    }
    
    func turn(_ direction: Direction) -> Direction {
        switch (self, direction) {
        case (.up, .right), (.down, .left): return .right
        case (.left, .right), (.right, .left): return .up
        case (.down, .right), (.up, .left): return .left
        case (.right, .right), (.left, .left): return .down
        default: fatalError("Invalid turn.")
        }
    }
}
