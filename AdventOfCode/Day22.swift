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
        let fileInput = String.input(forDay: 22)
//        let testInput = """
//                        ..#
//                        #..
//                        ...
//                        """
        let input = fileInput
        let grid = Grid(content: input)
        grid.burst()

        stageOneOutput = "\(grid.infections)"
        
//        var previousEvolution = grid
//        var infections = 0
//        for i in 1...10_000_000 {
//            let evolution = previousEvolution.evolve()
//            if evolution.didInfect { infections += 1 }
//            previousEvolution = evolution.grid
//            if i % 100_000 == 0 { print("Evolutions: \(i), Infections: \(infections)") }
//        }
//
        let evolutionGrid = Grid(content: input)
        evolutionGrid.evolve()
        
        stageTwoOutput = "\(evolutionGrid.infections)"
    }
    
    
}

final class Grid {
    private var content: [Point: Node]
    private var virus: Virus
    private(set) var infections = 0
    
    init(content: String) {
        let lines = content.split(separator: "\n")
        let nodes = lines.map { $0.flatMap { Node(rawValue: $0) } }
        assert(nodes.count % 2 == 1 && nodes[0].count % 2 == 1)
        let middle = nodes.count / 2
        var nodeMap: [Point: Node] = [:]
        for (y, line) in nodes.enumerated() {
            for (x, node) in line.enumerated() {
                let offsetX = x - middle
                let offsetY = middle - y
                let point = Point(offsetX, offsetY)
                nodeMap[point] = node
            }
        }
        
        self.content = nodeMap
        virus = Virus(position: Point(0, 0), facing: .up)
    }
    
    func burst() {
        for _ in 0..<10_000 {
            let currentNode = self[virus.position]
            if currentNode == .clean { infections += 1 }
            let currentPosition = virus.position
            virus = virus.simpleMove(from: self[currentPosition])
            self[currentPosition] = self[currentPosition].swap()
            
        }
    }
    
    func evolve() {
        for _ in 0..<10_000_000 {
            let currentNode = self[virus.position]
            if currentNode == .weakened { infections += 1 }
            let currentPosition = virus.position
            virus = virus.complexMove(from: self[currentPosition])
            self[currentPosition] = self[currentPosition].evolve()
        }
    }
    
//    func evolve() {
//        var newContent = content
//        let newVirus = virus.complexMove(from: self[virus.position])
//        let original = self[virus.position]
//        let didInfect = (original == .weakened)
//        newContent[virus.position] = self[virus.position].evolve()
//        let grid = Grid(content: newContent, virus: newVirus)
//
//        return (grid, didInfect)
//    }
    
    subscript(point: Point) -> Node {
        get {
            return content[point] ?? .clean
        }
        set {
            content[point] = newValue
        }
    }
}

extension Grid: CustomStringConvertible {
    var description: String {
        return content.description
    }
}

enum Node: Character {
    case clean = "."
    case infected = "#"
    case weakened = "W"
    case flagged = "F"
    
    func swap() -> Node {
        switch self {
        case .clean: return .infected
        case .infected: return .clean
        default: fatalError("Invalid value for swap.")
        }
    }
    
    func evolve() -> Node {
        switch self {
        case .clean: return .weakened
        case .weakened: return .infected
        case .infected: return .flagged
        case .flagged: return .clean
        }
    }
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

extension Point: CustomStringConvertible {
    var description: String {
        return "(\(x), \(y))"
    }
}

func + (lhs: Point, rhs: (x: Int, y: Int)) -> Point {
    let x = lhs.x + rhs.x
    let y = lhs.y + rhs.y
    return Point(x, y)
}

struct Virus {
    let position: Point
    let facing: Direction
    
    func simpleMove(from node: Node) -> Virus {
        let newDirection = facing.simpleTurn(from: node)
        let newPosition = position + newDirection.forwardOffset
        return Virus(position: newPosition, facing: newDirection)
    }
    
    func complexMove(from node: Node) -> Virus {
        let newDirection = facing.complexTurn(from: node)
        let newPosition = position + newDirection.forwardOffset
        return Virus(position: newPosition, facing: newDirection)
    }
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
    
    var reverse: Direction {
        switch self {
        case .up: return .down
        case .down: return .up
        case .left: return .right
        case .right: return .left
        }
    }
    
    func simpleTurn(from node: Node) -> Direction {
        switch node {
        case .clean: return turn(.left)
        case .infected: return turn(.right)
        default: fatalError("Invalid simple turn.")
        }
    }
    
    func complexTurn(from node: Node) -> Direction {
        switch node {
        case .clean: return turn(.left)
        case .weakened: return self
        case .infected: return turn(.right)
        case .flagged: return reverse
        }
    }
}

extension Array {
    func count(where predicate: (Element) -> Bool) -> Int {
        var count = 0
        for element in self {
            if predicate(element) {
                count += 1
            }
        }
        
        return count
    }
}
