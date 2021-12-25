//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayTwentyFive(input: String, output: inout DayOutput) async {
//        let input = """
//        v...>>.vv>
//        .vv>>.vv..
//        >>.>v>...v
//        >>v>>.>.v.
//        v>v.vv.v..
//        >.>>..v...
//        .vv..>.>v.
//        v.v..>>v.v
//        ....v..v.>
//        """

        let floor = Grid(input.byLines().map { $0.map { $0 } })

        let points = floor.points
        var first = floor
        var second = first
        var third = first
        var steps = 0
        repeat {
            steps += 1
            second = first
            third = first

            for point in points {
                guard second[point] == ">" else { continue }

                let checkPoint = floor.wrappingPoint(from: point, in: .right)
                if second[checkPoint] == "." {
                    first[checkPoint] = ">"
                    first[point] = "."
                }
            }

            second = first

            for point in points {
                guard second[point] == "v" else { continue }

                let checkPoint = floor.wrappingPoint(from: point, in: .up)
                if second[checkPoint] == "." {
                    first[checkPoint] = "v"
                    first[point] = "."
                }
            }
        } while first != third

        output.stepOne = "\(steps)"
        output.expectedStepOne = "560"
    }
}
