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

        var lanternFish: [Int: Int] = numbers.reduce(into: [:]) { partialResult, value in
            partialResult[value, default: 0] += 1
        }
        var nextFish: [Int: Int] = [:]
        for day in 0..<256 {
            for age in 0...8 {
                if age == 0 {
                    guard let count = lanternFish[age], count > 0 else { continue }

                    nextFish[6, default: 0] += count
                    nextFish[8, default: 0] = count
                } else {
                    guard let count = lanternFish[age], count > 0 else { continue }

                    nextFish[age - 1, default: 0] += count
                }
            }

            lanternFish = nextFish
            nextFish.removeAll(keepingCapacity: true)

            if day == 79 {
                output.stepOne = "\(lanternFish.values.sum)"
            }
        }

        output.stepTwo = "\(lanternFish.values.sum)"

        output.expectedStepOne = "352872"
        output.expectedStepTwo = "1604361182149"
    }
}
