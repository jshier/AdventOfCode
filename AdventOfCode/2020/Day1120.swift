//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

final class Day1120: Day {
    override var expectedStageOneOutput: String? { "2470" }
    override var expectedStageTwoOutput: String? { "2259" }

    override func perform() async {
        let input = String.input(forDay: 11, year: 2020)
//        let input = """
//        L.LL.LL.LL
//        LLLLLLL.LL
//        L.L.L..L..
//        LLLL.LL.LL
//        L.LL.LL.LL
//        L.LLLLL.LL
//        ..L.L.....
//        LLLLLLLLLL
//        L.LLLLLL.L
//        L.LLLLL.LL
//        """

        enum Seat: String, CustomStringConvertible {
            case empty = "L"
            case taken = "#"
            case floor = "."

            var description: String { rawValue }
        }
        let initialSeats = input.byLines().map { $0.map(String.init).compactMap(Seat.init(rawValue:)) }

        let initialGrid = Grid(initialSeats)
        let (part1, part2) = await inParallel {
            func iteratedGrid(from grid: Grid<Seat>) -> Grid<Seat> {
                var nextGrid = grid
                for point in grid.points {
                    let value = grid[point]
                    if value == .floor {
                        continue
                    } else {
                        let surroundingPoints = point.surroundingPoints
                        let occupiedCount = surroundingPoints.reduce(0) { result, value in
                            guard value.x >= 0, value.x < grid.width, value.y >= 0, value.y < grid.height else { return result }

                            return grid[value] == .taken ? result + 1 : result
                        }
                        if value == .empty && occupiedCount == 0 {
                            nextGrid[point] = .taken
                        } else if value == .taken && occupiedCount >= 4 {
                            nextGrid[point] = .empty
                        }
                    }
                }

                return nextGrid
            }

            var grid = initialGrid
            var nextGrid = iteratedGrid(from: grid)
            while nextGrid != grid {
                grid = nextGrid
                nextGrid = iteratedGrid(from: grid)
            }
            let finalSeatsTaken = nextGrid.values.count(of: .taken)

            return "\(finalSeatsTaken)"
        } part2: {
            func rayIteratedGrid(from grid: Grid<Seat>) -> Grid<Seat> {
                var nextGrid = grid
                for point in grid.points {
                    let value = grid[point]
                    if value == .floor {
                        continue
                    } else {
                        var occupiedRays = 0
                        for ray in point.rays(maxX: grid.width - 1, maxY: grid.height - 1) {
                            ray: for rayPoint in ray {
                                let rayValue = grid[rayPoint]
                                switch rayValue {
                                case .floor:
                                    continue
                                case .taken:
                                    occupiedRays += 1
                                    break ray
                                case .empty:
                                    break ray
                                }
                            }
                        }
                        if value == .empty && occupiedRays == 0 {
                            nextGrid[point] = .taken
                        } else if value == .taken && occupiedRays >= 5 {
                            nextGrid[point] = .empty
                        }
                    }
                }

                return nextGrid
            }

            var rayGrid = initialGrid
            var nextRayGrid = rayIteratedGrid(from: rayGrid)
            while nextRayGrid != rayGrid {
                rayGrid = nextRayGrid
                nextRayGrid = rayIteratedGrid(from: rayGrid)
            }
            let finalRaySeatsTaken = nextRayGrid.values.count(of: .taken)

            return "\(finalRaySeatsTaken)"
        }

        stageOneOutput = "\(part1)"
        stageTwoOutput = "\(part2)"
    }
}

struct Grid<Element> {
    private(set) var values: [Element]

    let height: Int
    let width: Int
    let points: PointSequence

    init(_ values: [[Element]]) {
        self.values = values.flatMap { $0 }
        height = values.count
        width = values[0].count
        points = PointSequence(start: .origin, end: Point(width - 1, height - 1))
    }

    init(_ values: [Element], height: Int, width: Int) {
        self.values = values
        self.height = height
        self.width = width
        points = PointSequence(start: .origin, end: Point(width, height))
    }

    init(repeating value: Element, size: Int) {
        values = Array(repeating: value, count: size * size + 1)
        width = size
        height = size
        points = PointSequence(start: .origin, end: Point(width, height))
    }

    @inline(__always)
    @inlinable
    subscript(_ point: Point) -> Element {
        get { values[width * point.y + point.x] }
        set { values[width * point.y + point.x] = newValue }
    }

    @inline(__always)
    @inlinable
    subscript(_ x: Int, _ y: Int) -> Element {
        get { values[width * y + x] }
        set { values[width * y + x] = newValue }
    }

    func surroundingValues(for point: Point) -> [Element] {
        let points = point.surroundingPoints.filter { ($0.x >= 0 && $0.x < width) && ($0.y >= 0 && $0.y < height) }

        return points.map { self[$0] }
    }

    func point(forValue value: Element) -> Point? where Element: Equatable {
        guard let index = values.firstIndex(of: value) else { return nil }

        return Point(index % width, index / width)
    }
}

extension Grid: Sendable where Element: Sendable {}

extension Grid: Sequence {
    func makeIterator() -> some IteratorProtocol {
        values.makeIterator()
    }
}

extension Grid: Equatable where Element: Equatable {
    static func == (_ lhs: Grid, _ rhs: Grid) -> Bool {
        lhs.values == rhs.values
    }
}

// extension Grid: CustomStringConvertible {
//    var description: String {
//        values.map(String.init(describing:)).joined().chunked(into: width).joined(separator: "\n")
//    }
// }
