//
//  Day5.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import CoreFoundation

extension TwentySeventeen {
    func dayFive(_ output: inout DayOutput) async {
        let input = String.input(forDay: .five, year: .seventeen)
        let program = input.byLines().asInts()

        let (partOne, partTwo) = await inParallel {
            var instructions = program
            var index = instructions.startIndex
            var steps = 0
            while index < instructions.endIndex {
                let jump = instructions[index]
                instructions[index] += 1
                index = index + jump
                steps += 1
            }

            return "\(steps)"
        } part2: {
            var instructions = program
            var index = instructions.startIndex
            var steps = 0
            while index < instructions.endIndex {
                let jump = instructions[index]
                instructions[index] += (jump >= 3) ? -1 : 1
                index = index + jump
                steps += 1
            }

            return "\(steps)"
        }

        output.stepOne = partOne
        output.expectedStepOne = "391540"
        output.stepTwo = partTwo
        output.expectedStepTwo = "30513679"
    }
}
