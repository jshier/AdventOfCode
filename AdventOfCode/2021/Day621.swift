//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func daySix(_ output: inout DayOutput) async {
        let input = String.input(forDay: .six, year: .twentyOne)
//        let input = "3,4,3,1,2"
        let numbers = input.byCommas().asInts()

        var lanternFish: [Int] = numbers.reduce(into: Array(repeating: 0, count: 9)) { partialResult, value in
            partialResult[value] += 1
        }
        var nextFish: [Int] = Array(repeating: 0, count: 9)
        for day in 0..<256 {
            for age in 0...8 {
                if age == 0 {
                    let count = lanternFish[age]
                    guard count > 0 else { continue }

                    nextFish[6] += count
                    nextFish[8] = count
                } else {
                    let count = lanternFish[age]
                    guard count > 0 else { continue }

                    nextFish[age - 1] += count
                }
            }

            lanternFish = nextFish
            nextFish = Array(repeating: 0, count: 9)

            if day == 79 {
                output.stepOne = "\(lanternFish.sum)"
            }
        }

        output.stepTwo = "\(lanternFish.sum)"

        output.expectedStepOne = "352872"
        output.expectedStepTwo = "1604361182149"
    }
}
