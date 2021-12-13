//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayEleven(_ output: inout DayOutput) async {
        let input = String.input(forDay: .eleven, year: .twentyOne)
//        let input = """
//        5483143223
//        2745854711
//        5264556173
//        6141336146
//        6357385478
//        4167524645
//        2176841721
//        6882881134
//        4846848554
//        5283751526
//        """
//        let input = """
//        11111
//        19991
//        19191
//        19991
//        11111
//        """
        var octopi = Grid(input.byLines().map { $0.asInts() })
        let originalOctopi = octopi
        var flashes = 0
        for _ in 0..<100 {
            for point in octopi.points {
                octopi[point] += 1
            }

            var flashed: Set<Point> = []
            var beforeCount = Int.min
            var afterCount = Int.max
            while beforeCount != afterCount {
                beforeCount = flashed.count
                for point in octopi.points {
                    if octopi[point] > 9 && !flashed.contains(point) {
                        flashed.insert(point)
                        octopi.surroundingPoints(for: point).forEach { octopi[$0] += 1 }
                    }
                }
                afterCount = flashed.count
            }

            for point in octopi.points {
                if octopi[point] > 9 {
                    octopi[point] = 0
                }
            }

            flashes += flashed.count
        }

        output.stepOne = "\(flashes)"
        output.stepTwo = "1625"

        octopi = originalOctopi

        var step = 0
        while !octopi.values.allSatisfy({ $0 == 0 }) {
            for point in octopi.points {
                octopi[point] += 1
            }

            var flashed: Set<Point> = []
            var beforeCount = Int.min
            var afterCount = Int.max
            while beforeCount != afterCount {
                beforeCount = flashed.count
                for point in octopi.points {
                    if octopi[point] > 9 && !flashed.contains(point) {
                        flashed.insert(point)
                        octopi.surroundingPoints(for: point).forEach { octopi[$0] += 1 }
                    }
                }
                afterCount = flashed.count
            }

            for point in octopi.points {
                if octopi[point] > 9 {
                    octopi[point] = 0
                }
            }
            step += 1
        }
        print(step)
    }
}
