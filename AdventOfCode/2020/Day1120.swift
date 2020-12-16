//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1120: Day {
    override var expectedStageOneOutput: String? { "2470" }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() {
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
            case taken = "X"
            case floor = "."
            
            var description: String { rawValue }
        }
        
        let initialSeats = input.byLines().map { $0.map(String.init).compactMap(Seat.init(rawValue:)) }
        
        let initialGrid = Grid(initialSeats)
//        let points = initialGrid.containedPoints
//        let seatPoints = points.filter { !(initialGrid[$0] == .floor) }
        
        var grids: [Grid<Seat>] = [initialGrid]
        var iterations = 0
        while let grid = grids.last {
            iterations += 1
            let newValues: [[Seat]] = (0..<grid.height).map { y in
                (0..<grid.width).map { x in
                    let point = Point(x, y)
                    let value = grid[point]
                    if value == .floor {
                        return .floor
                        
                    } else {
                        let surrounding = grid.surroundingValues(for: point)
                        let occupiedCount = surrounding.count { $0 == .taken }
                        if value == .empty && occupiedCount == 0 {
                            return .taken
                        } else if value == .taken && occupiedCount >= 4 {
                            return .empty
                        } else {
                            return value
                        }
                    }
                }
            }
            if newValues == grid.values {
                break
            } else {
                grids.append(Grid(newValues))
            }
        }
        
        let finalSeatsTaken = grids.last?.values.reduce(0) { $0 + $1.count(of: .taken) } ?? 0
        print(iterations)
        stageOneOutput = "\(finalSeatsTaken)"
    }
}

struct Grid<T> {
    private(set) var values: [[T]]
    
    var height: Int { values.count }
    var width: Int { values.first?.count ?? 0 }
    
    var containedPoints: [Point] {
        Array(PointSequence(start: .init(0, 0), end: .init(width - 1, height - 1)))
    }
    
    init(_ values: [[T]]) {
        self.values = values
    }
    
    subscript (_ point: Point) -> T {
        get { values[point.y][point.x] }
        set { values[point.y][point.x] = newValue }
    }
    
    func surroundingValues(for point: Point) -> [T] {
        let points: [Point] =  point.surroundingPoints.filter { ($0.x >= 0 && $0.x < values[0].count) && ($0.y >= 0 && $0.y < values.count) }
        return points.map { self[$0] }
    }
}
