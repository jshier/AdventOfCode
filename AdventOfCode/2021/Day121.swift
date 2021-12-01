//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

final class TwentyTwentyOne: Runner {
    var year: Year { .twentyOne }
}

extension TwentyTwentyOne {
    func dayOne(_ output: inout DayOutput) async {
        let input = String.input(forDay: .one, year: .twentyOne)
        let depths = input.byLines().asInts()
        let (stepOne, stepTwo) = await inParallel {
            let increases = depths.adjacentPairs().count(where: <)

            return "\(increases)"
        } part2: {
            let increases = depths.windows(ofCount: 3).map(\.sum).adjacentPairs().count(where: <)

            return "\(increases)"
        }

        output.stepOne = stepOne
        output.expectedStepOne = "1624"

        output.stepTwo = stepTwo
        output.expectedStepTwo = "1653"
    }
}
