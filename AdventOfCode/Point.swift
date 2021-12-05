//
//  Point.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/14/21.
//  Copyright © 2021 Jon Shier. All rights reserved.
//

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
    private static var surroundingPointCache: [Point: [Point]] = [:]

    static let surroundingOffsets = [(0, 1), (1, 0), (0, -1), (-1, 0), (-1, 1), (1, -1), (1, 1), (-1, -1)]

    var surroundingPoints: [Point] {
        if let points = Point.surroundingPointCache[self] {
            return points
        } else {
            let points = Point.surroundingOffsets.map { self + $0 }
            Point.surroundingPointCache[self] = points
            return points
        }
    }

    static let adjacentOffsets = [(0, 1), (1, 0), (0, -1), (-1, 0)]

    var adjacentPoints: [Point] {
        Point.adjacentOffsets.map { self + $0 }
    }

    var product: Int { x * y }

    var squareDistance: Int {
        abs(x) + abs(y)
    }

    var straightDistance: Double {
        Double(x * x + y * y).squareRoot()
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
        Double(((point.x - x) * (point.x - x)) +
            ((point.y - y) * (point.y - y))).squareRoot()
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

@inline(__always)
func + (lhs: Point, rhs: Point) -> Point {
    let x = lhs.x + rhs.x
    let y = lhs.y + rhs.y
    return Point(x, y)
}

@inline(__always)
func + (lhs: Point, rhs: (x: Int, y: Int)) -> Point {
    let x = lhs.x + rhs.x
    let y = lhs.y + rhs.y
    return Point(x, y)
}

@inline(__always)
func + (lhs: Point, rhs: Offset) -> Point {
    let x = lhs.x + rhs.dx
    let y = lhs.y + rhs.dy
    return Point(x, y)
}

@inline(__always)
func += (lhs: inout Point, rhs: Point) {
    lhs = lhs + rhs
}

@inline(__always)
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

    @inlinable
    @inline(__always)
    init(start: Point, end: Point) {
        precondition(start <= end)
        self.start = start
        self.end = end
        nextValue = start
    }

    @inlinable
    @inline(__always)
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

struct PointRayIterator: IteratorProtocol {
    let origin: Point
    let offset: (Int, Int)
    let minX: Int
    let minY: Int
    let maxX: Int
    let maxY: Int

    private var nextValue: Point

    @inlinable
    @inline(__always)
    init(origin: Point, offset: (Int, Int), minX: Int, minY: Int, maxX: Int, maxY: Int) {
        self.origin = origin
        self.offset = offset
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
        nextValue = origin + offset
    }

    @inlinable
    @inline(__always)
    mutating func next() -> Point? {
        guard nextValue.x >= minX, nextValue.x <= maxX, nextValue.y >= minY, nextValue.y <= maxY else { return nil }

        let current = nextValue

        nextValue = nextValue + offset

        return current
    }
}

struct PointRaySequence: Sequence {
    let origin: Point
    let offset: (Int, Int)
    let minX: Int
    let minY: Int
    let maxX: Int
    let maxY: Int

    func makeIterator() -> PointRayIterator {
        PointRayIterator(origin: origin, offset: offset, minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
}

extension Point {
    func rays(minX: Int = 0, maxX: Int, minY: Int = 0, maxY: Int) -> [PointRaySequence] {
        Point.surroundingOffsets.map {
            PointRaySequence(origin: self, offset: $0, minX: minX, minY: minY, maxX: maxX, maxY: maxY)
        }
    }
}

struct PointVectorIterator: IteratorProtocol {
    let start: Point
    let end: Point

    private let offset: (Int, Int)
    private let pastTheEndPoint: Point
    private var nextValue: Point

    init(start: Point, end: Point) {
        self.start = start
        self.end = end
        let dx = end.x - start.x
        let dy = end.y - start.y
        offset = (dx.vectorOffset, dy.vectorOffset)
        nextValue = start
        pastTheEndPoint = end + offset
    }

    @inlinable
    @inline(__always)
    mutating func next() -> Point? {
        guard nextValue != pastTheEndPoint else { return nil }

        let current = nextValue

        nextValue = current + offset

        return current
    }
}

struct PointVectorSequence: Sequence {
    let start: Point
    let end: Point

    func makeIterator() -> PointVectorIterator {
        PointVectorIterator(start: start, end: end)
    }
}

extension Point {
    func vector(to point: Point) -> PointVectorSequence {
        PointVectorSequence(start: self, end: point)
    }
}
