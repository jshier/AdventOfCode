//
//  Day6.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/16/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

extension TwentySeventeen {
    func daySix(_ output: inout DayOutput) async {
        let fileInput = String.input(forDay: .six, year: .seventeen)
        let fileBanks = fileInput.byTabs().asInts()
        // let testBanks = [0, 2, 7, 0]
        var banks = fileBanks
        var seen: Set<String> = [banks.asString]
        var redistributions = 0

        func redistribute() {
            var (index, value) = banks.maxValueIndex()!
            banks[index] = 0
            while value > 0 {
                index = banks.circularIndex(after: index)
                banks[index] += 1
                value -= 1
            }
        }

        @discardableResult
        func redistributeUntilDuplicate() -> String {
            while true {
                redistribute()
                redistributions += 1
                let banksString = banks.asString
                if seen.contains(banksString) {
                    return banksString
                } else {
                    seen.insert(banksString)
                }
            }
        }

        redistributeUntilDuplicate()

        output.stepOne = "\(redistributions)"
        output.expectedStepOne = "11137"

        seen.removeAll()
        seen.insert(banks.asString)

        redistributions = 0
        redistributeUntilDuplicate()
        output.stepTwo = "\(redistributions)"
        output.expectedStepTwo = "1037"
    }
}
