//
//  Day15.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/15/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day15: Day {
    override func perform() async {
        let aStart = 703
        let bStart = 516
        let aFactor = 16_807
        let bFactor = 48_271
        let divisor = 2_147_483_647

        var aResult = aStart
        var bResult = bStart
        var lower16BitMatches = 0
        var aPowers: [Int] = []
        var bPowers: [Int] = []
        for _ in 0..<40_000_000 {
            aResult = (aResult * aFactor) % divisor
            bResult = (bResult * bFactor) % divisor
            if aResult % 4 == 0 { aPowers.append(aResult) }
            if bResult % 8 == 0 { bPowers.append(bResult) }
            if aResult.lower16BitsEqual(lower16BitsOf: bResult) { lower16BitMatches += 1 }
        }

        stageOneOutput = "\(lower16BitMatches)"

        let lower16BitPowerMatches = zip(aPowers, bPowers).filter { $0.0.lower16BitsEqual(lower16BitsOf: $0.1) }.count

        stageTwoOutput = "\(lower16BitPowerMatches)"
    }
}
