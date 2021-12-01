//
//  Day1.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class TwentySeventeen: Runner {
    var year: Year { .seventeen }
}

extension TwentySeventeen {
    func dayOne(_ output: inout DayOutput) async {
        let input = String.input(forDay: .one, year: .seventeen)
        let calculator = CaptchaCalculator(input)

        output.stepOne = "\(calculator.calculateCircularSum())"
        output.expectedStepOne = "1102"
        output.stepTwo = "\(calculator.calculateHalfwaySum())"
        output.expectedStepTwo = "1076"
    }
}

private struct CaptchaCalculator {
    let storage: [Int]

    init(_ input: String) {
        storage = input.asInts()
    }

    func calculateCircularSum() -> Int {
        var sum = 0
        var index = storage.startIndex
        while index < storage.endIndex {
            let potentialNextIndex = storage.index(after: index)
            let nextIndex = (potentialNextIndex == storage.endIndex) ? storage.startIndex : potentialNextIndex

            if storage[index] == storage[nextIndex] && index != nextIndex {
                sum += storage[index]
            }

            index = potentialNextIndex
        }

        return sum
    }

    func calculateHalfwaySum() -> Int {
        var sum = 0
        var index = storage.startIndex
        var middleIndex = storage.index(index, offsetBy: storage.count / 2)
        while index < storage.endIndex {
            if storage[index] == storage[middleIndex] {
                sum += storage[index]
            }

            let potentialNextMiddleIndex = storage.index(after: middleIndex)
            middleIndex = (potentialNextMiddleIndex == storage.endIndex) ? storage.startIndex : potentialNextMiddleIndex
            index = storage.index(after: index)
        }

        return sum
    }
}
