//
//  Day13.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/26/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day13: Day {
    override func perform() {
        let fileInput = String.input(forDay: 13, year: 2017)
//        let testInput = """
//                        0: 3
//                        1: 2
//                        4: 4
//                        6: 4
//                        """
        let input = fileInput
        let lines = input.split(separator: "\n")
        let scanners = lines.map { $0.components(separatedBy: ": ").compactMap(Int.init) }
        let scanner = Dictionary(zip(scanners.map { $0[0] }, scanners.map { $0[1] })) { _, rhs in rhs }

        var violations: [Int] = []
        for nanosecond in 0...scanner.keys.max()! {
            guard let value = scanner[nanosecond] else { continue }

            if nanosecond % value.bounceBack == 0 {
                violations.append(nanosecond * value)
            }
        }

        stageOneOutput = "\(violations.reduce(0, +))"

        var hasViolation = true
        var delay = 0

        while hasViolation {
            var violation = false
            inner: for nanosecond in 0...scanner.keys.max()! {
                guard let value = scanner[nanosecond] else { continue }

                if (nanosecond + delay) % value.bounceBack == 0 {
                    violation = true
                    break inner
                }
            }
            if violation { delay += 1 }
            hasViolation = violation
        }

        stageTwoOutput = "\(delay)"
    }
}

extension Int {
    var bounceBack: Int {
        guard self != 1 else { return 1 }

        return self + (self - 2)
    }
}
