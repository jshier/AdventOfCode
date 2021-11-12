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
        let fileInput = String.input(forDay: 22, year: 2017)
//        let testInput = """
//                        ..#
//                        #..
//                        ...
//                        """
        let input = fileInput
        let grid = VirusGrid(content: input)
        grid.burst()

        stageOneOutput = "\(grid.infections)"

        let evolutionGrid = VirusGrid(content: input)
        evolutionGrid.evolve()

        stageTwoOutput = "\(evolutionGrid.infections)"
    }
}

final class VirusGrid {
    private var content: [Point: Node]
    private var virus: Virus
    private(set) var infections = 0

    init(content: String) {
        let lines = content.split(separator: "\n")
        let nodes = lines.map { $0.compactMap { Node(rawValue: $0) } }
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

    subscript(point: Point) -> Node {
        get {
            content[point] ?? .clean
        }
        set {
            content[point] = newValue
        }
    }
}

extension VirusGrid: CustomStringConvertible {
    var description: String {
        content.description
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
        String(rawValue)
    }
}

struct Point: Hashable, Codable {
    static let origin = Point(0, 0)

    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

extension Point {
    static let surroundingOffsets = [(0, 1), (1, 0), (0, -1), (-1, 0), (-1, 1), (1, -1), (1, 1), (-1, -1)]

    var surroundingPoints: [Point] {
        Point.surroundingOffsets.map { self + $0 }
    }

    static let adjacentOffsets = [(0, 1), (1, 0), (0, -1), (-1, 0)]

    var adjacentPoints: [Point] {
        Point.adjacentOffsets.map { self + $0 }
    }

    var squareDistance: Int {
        abs(x) + abs(y)
    }

    var straightDistance: Double {
        sqrt(Double(x * x + y * y))
    }

    func perpendicularPoints(for direction: Direction) -> [Point] {
        switch direction {
        case .up, .down: return [Direction.left, Direction.right].map { self + $0.forwardOffset }
        case .left, .right: return [Direction.up, Direction.down].map { self + $0.forwardOffset }
        }
    }

    func manhattanDistance(to point: Point) -> Int {
        abs(x - point.x) + abs(y - point.y)
    }

    func offset(of point: Point) -> Offset {
        Offset(point.x - x, point.y - y)
    }

    func distance(to point: Point) -> Double {
        sqrt(Double(((point.x - x) * (point.x - x)) +
                ((point.y - y) * (point.y - y))))
    }

    func rotated(_ direction: Direction) -> Point {
        switch direction {
        case .left:
            return Point(-y, x)
        case .right:
            return Point(y, -x)
        case .up: // Unimplemented
            return self
        case .down: // Unimplemented
            return self
        }
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

extension Point: Comparable {
    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.x < rhs.x || (lhs.x == rhs.x && lhs.y < rhs.y)
    }
}

func + (lhs: Point, rhs: Point) -> Point {
    let x = lhs.x + rhs.x
    let y = lhs.y + rhs.y
    return Point(x, y)
}

func + (lhs: Point, rhs: (x: Int, y: Int)) -> Point {
    let x = lhs.x + rhs.x
    let y = lhs.y + rhs.y
    return Point(x, y)
}

func + (lhs: Point, rhs: Offset) -> Point {
    let x = lhs.x + rhs.dx
    let y = lhs.y + rhs.dy
    return Point(x, y)
}

func += (lhs: inout Point, rhs: Point) {
    lhs = lhs + rhs
}

func += (lhs: inout Point, rhs: (x: Int, y: Int)) {
    lhs = lhs + rhs
}

extension Point {
    init<S: StringProtocol>(_ string: S) {
        let elements = string.split(separator: ",")
            .compactMap { Int($0) }
        x = elements[0]
        y = elements[1]
    }
}

struct PointIterator: IteratorProtocol {
    let start: Point
    let end: Point
    var nextValue: Point

    init(start: Point, end: Point) {
        precondition(start <= end)
        self.start = start
        self.end = end
        nextValue = start
    }

    mutating func next() -> Point? {
        // Iterate x then y
        guard nextValue <= end else { return nil }

        let current = nextValue
        if current.x < end.x {
            nextValue = Point(current.x + 1, current.y)
        } else if current.y < end.y {
            nextValue = Point(start.x, current.y + 1)
        } else if current.x == end.x && current.y == end.y {
            nextValue = Point(current.x + 1, current.y)
        }

        return current
    }
}

struct PointSequence: Sequence {
    let start: Point
    let end: Point

    func makeIterator() -> PointIterator {
        PointIterator(start: start, end: end)
    }
}

struct Offset: Hashable {
    let dx, dy: Int
}

extension Offset {
    init(_ dx: Int, _ dy: Int) {
        self.dx = dx
        self.dy = dy
    }
}

extension Offset {
    var length: Int {
        dx * dx + dy * dy
    }

    func clockwiseAngle(to offset: Offset) -> Double {
        var angle = atan2(Double(offset.dy), Double(offset.dx)) - atan2(Double(dy), Double(dx))

        if angle < 0 { angle += 2 * Double.pi }

        return angle
    }

    func isMultiple(of other: Offset) -> Bool {
        (dy * other.dx) == (dx * other.dy) &&
            ((dy.signum() == other.dy.signum()) &&
                (dx.signum() == other.dx.signum()))
    }
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

enum Direction: Int, CaseIterable {
    case up = 1, down, left, right

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

    func offset(_ point: Point) -> Point {
        point + forwardOffset
    }
}

private extension Direction {
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
