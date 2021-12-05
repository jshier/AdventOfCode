//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation
import SE0270_RangeSet

extension TwentyTwentyOne {
    func dayFive(_ output: inout DayOutput) async {
        let input = String.input(forDay: .five, year: .twentyOne)
//        let input = """
//        0,9 -> 5,9
//        8,0 -> 0,8
//        9,4 -> 3,4
//        2,2 -> 2,1
//        7,0 -> 7,4
//        6,4 -> 2,0
//        0,9 -> 2,9
//        3,4 -> 1,4
//        0,0 -> 8,8
//        5,5 -> 8,2
//        """

        let ranges = input.byLines()
            .map { $0.components(separatedBy: " -> ") }
            .map { $0.map { $0.byCommas().asInts() } }

        await into(&output) { () -> Int in
            let lines = ranges.flatMap { arrays -> [Point] in
                let x1 = arrays[0][0]
                let x2 = arrays[1][0]
                let y1 = arrays[0][1]
                let y2 = arrays[1][1]
                if x1 == x2 || y1 == y2 {
                    return Point(x1, y1).vector(to: .init(x2, y2)).asArray()
                } else {
                    return []
                }
            }
            let counted = CountedSet(lines)

            return counted.filter { counted.count(for: $0) >= 2 }.count
        } part2: { () -> Int in
            let diagonals = ranges.flatMap { arrays -> [Point] in
                let x1 = arrays[0][0]
                let x2 = arrays[1][0]
                let y1 = arrays[0][1]
                let y2 = arrays[1][1]

                return Point(x1, y1).vector(to: .init(x2, y2)).asArray()
            }

            let countedDiagonals = CountedSet(diagonals)

            return countedDiagonals.filter { countedDiagonals.count(for: $0) >= 2 }.count
        }

        output.expectedStepOne = "7318"
        output.expectedStepTwo = "19939"
    }
}
