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

        await into(&output) {
            depths.adjacentPairs().count(where: <)
        } part2: {
            depths.windows(ofCount: 3).map(\.sum).adjacentPairs().count(where: <)
        }

        output.expectedStepOne = "1624"
        output.expectedStepTwo = "1653"
    }
}

extension Int {
    func into(_ output: inout String?) {
        output = "\(self)"
    }
}
