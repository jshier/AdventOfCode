//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func daySeven(_ output: inout DayOutput) async {
        let input = String.input(forDay: .seven, year: .twentyOne)

        let crabs = input.byCommas().asInts().sorted()

        await into(&output) { () -> Int in
            let median = crabs.median

            return crabs.reduce(0) { result, crab in
                result + abs(crab - median)
            }
        } part2: { () -> Int in
            let average = crabs.average

            return crabs.reduce(0) { result, crab in
                result + abs(crab - average).sum
            }
        }

        output.expectedStepOne = "344735"
        output.expectedStepTwo = "96798233"
    }
}
