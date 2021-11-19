//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day419: Day {
    override var expectedStageOneOutput: String? { "2779" }
    override var expectedStageTwoOutput: String? { "1972" }

    override func perform() async {
        // let input = "108457-562041"
        let passwords: [Int] = (108_457...562_041).compactMap { ($0.containsDoublesAndIncreases) ? $0 : nil }

        stageOneOutput = "\(passwords.count)"

        let realPasswords = passwords.compactMap { $0.containsAtLeastOneDouble ? $0 : nil }

        stageTwoOutput = "\(realPasswords.count)"
    }
}

extension Int {
    var containsDoublesAndIncreases: Bool {
        var containsDoubles = false
        var value = self
        var lastDigit = value % 10
        value /= 10
        while value > 0 {
            let digit = value % 10
            if digit > lastDigit {
                return false
            }
            value /= 10
            if lastDigit == digit { containsDoubles = true }
            lastDigit = digit
        }

        return containsDoubles
    }

    var containsAtLeastOneDouble: Bool {
        var value = self
        var digitCounts: [Int] = Array(repeating: 0, count: 10)
        while value > 0 {
            let digit = value % 10
            digitCounts[digit] += 1
            value /= 10
        }

        return digitCounts.contains(2)
    }

    var digits: [Int] {
        var digits: [Int] = []
        var value = self
        while value > 0 {
            let remainder = value % 10
            digits.append(remainder)
            value /= 10
        }

        return digits.reversed()
    }
}
