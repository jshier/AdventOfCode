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
    let content: [Point: Node]
    
    init(content: String) {
        let lines = content.split(separator: "\n")
        let nodes = lines.map { $0.flatMap { Node(rawValue: $0) } }
        assert(nodes.count % 2 == 1 && nodes[0].count % 2 == 1)
        let middle = nodes.count / 2
        var nodeMap: [Point: Node] = [:]
        for (i, line) in nodes.enumerated() {
            for (j, node) in line.enumerated() {
                let point = Point(j, i)
            }
        }
        
        self.content = [:]
    }
    
    subscript(point: Point) -> Node {
        return content[point]!
    }
}

extension Grid: CustomStringConvertible {
    var description: String {
        return ""
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

struct Point: Hashable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

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
