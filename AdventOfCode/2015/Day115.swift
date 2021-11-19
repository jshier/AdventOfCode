//
//  Day115.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class TwentyFifteen: Runner {
    var year: Year { .fifteen }
}

extension TwentyFifteen {
    func dayOne(_ output: inout YearRunner.DayOutput) async {
        let input = String.input(forDay: .one, year: .fifteen)

        let openDifference = input.reduce(0) { result, element in
            result + (element == "(" ? 1 : -1)
        }

        output.stepOne = "\(openDifference)"
        output.expectedStepOne = "74"

        var value = 0
        var position = 0

        while value != -1 {
            value += (input[position] == "(") ? 1 : -1

            position += 1
        }

        output.stepTwo = "\(position)"
        output.expectedStepTwo = "1795"
    }
}
