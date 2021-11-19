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
                        for ray in point.rays(maxX: (grid.width - 1), maxY: (grid.height - 1)) {
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

struct Grid<T> {
    private(set) var values: [T]

    let height: Int
    let width: Int
    let points: PointSequence

    init(_ values: [[T]]) {
        self.values = values.flatMap { $0 }
        height = values.count
        width = values[0].count
        points = PointSequence(start: .origin, end: Point(width - 1, height - 1))
    }

    subscript(_ point: Point) -> T {
        get { values[width * point.y + point.x] }
        set { values[width * point.y + point.x] = newValue }
    }
    
    subscript(_ x: Int, _ y: Int) -> T {
        get { values[width * y + x] }
        set { values[width * y + x] = newValue }
    }

    func surroundingValues(for point: Point) -> [T] {
        let points = point.surroundingPoints.filter { ($0.x >= 0 && $0.x < width) && ($0.y >= 0 && $0.y < height) }
        
        return points.map { self[$0] }
    }
}

extension Grid: Sequence {
    func makeIterator() -> some IteratorProtocol {
        values.makeIterator()
    }
}

extension Grid: Equatable where T: Equatable {
    static func ==(_ lhs: Grid, _ rhs: Grid) -> Bool {
        lhs.values == rhs.values
    }
}

extension Grid: CustomStringConvertible {
    var description: String {
        values.map(String.init(describing:)).joined().chunked(into: width).joined(separator: "\n")
    }
}
