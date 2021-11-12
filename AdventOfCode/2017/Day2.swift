//
//  Day2.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

class Day2: Day {
    override func perform() {
        let input = String.input(forDay: 2, year: 2017)
        let lines = input.split(separator: "\n").map(String.init)
        let separatedLines = lines.map { $0.split(separator: "\t").map(String.init) }
        let numbers = separatedLines.map { $0.compactMap(Int.init) }
        let differences = numbers.map { $0.max()! - $0.min()! }
        let checksum = differences.reduce(0, +)
        stageOneOutput = "\(checksum)"

        let moduluses = numbers.map { sequence -> Int in
            var remainingNumbers = sequence.dropFirst()
            for value in sequence {
                for otherValue in remainingNumbers {
                    let values = [value, otherValue]
                    let max = values.max()!
                    let min = values.min()!
                    if max % min == 0 {
                        return max / min
                    }
                }

                remainingNumbers = remainingNumbers.dropFirst()
            }
            return 0
        }
        let modulusChecksum = moduluses.reduce(0, +)
        stageTwoOutput = "\(modulusChecksum)"
    }
}
