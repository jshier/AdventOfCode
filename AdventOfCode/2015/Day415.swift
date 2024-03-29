//
//  Day415.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

extension TwentyFifteen {
    func dayFour(_ output: inout DayOutput) async {
        let input = "ckczppom"

        let (stepOne, stepTwo) = await inParallel {
            var count = 0
            var hex = ""
            repeat {
                hex = "\(input)\(count)".md5()
                count += 1
            } while hex.prefix(5) != "00000"

            return "\(count - 1)"
        } part2: {
            var count = 0
            var dataHex = Data()
            let threeZeroBytes = Data(repeating: 0, count: 3)
            repeat {
                dataHex = "\(input)\(count)".md5Data()
                count += 1
                if count % 1_000_000 == 0 { print(count) }
            } while dataHex.prefix(3) != threeZeroBytes

            return "\(count - 1)"
        }

        output.stepOne = stepOne
        output.expectedStepOne = "117946"
        output.stepTwo = stepTwo
        output.expectedStepTwo = "3938038"
    }
}
