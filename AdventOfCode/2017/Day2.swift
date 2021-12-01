//
//  Day2.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

extension TwentySeventeen {
    func dayTwo(_ output: inout DayOutput) async {
        let input = String.input(forDay: .two, year: .seventeen)
        let numbers = input.byLines().map { $0.byTabs().asInts() }
        let checksum = numbers.map { $0.onMaxAndMin(-) }.sum

        output.stepOne = "\(checksum)"
        output.expectedStepOne = "44216"

        let moduluses = numbers.map { sequence -> Int in
            for (first, second) in sequence.allPairs() {
                let max = max(first, second)
                let min = min(first, second)

                if max % min == 0 {
                    return max / min
                }
            }
            return 0
        }
        let modulusChecksum = moduluses.sum

        output.stepTwo = "\(modulusChecksum)"
        output.expectedStepTwo = "320"
    }
}
