//
//  Day1018.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/10/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1118: Day {
    override var expectedStageOneOutput: String? { "(19, 41)" }
    override var expectedStageTwoOutput: String? { "(237, 284)x11" }
    
    override func perform() {
        let input = 5535
        
        var sums: [[Int]] = Array(repeating: Array(repeating: 0, count: 301), count: 301)
        
        for y in 1...300 {
            for x in 1...300 {
                let rackID = x + 10
                var power = rackID * y
                power += input
                power *= rackID
                power = (power / 100) % 10
                power -= 5
                sums[y][x] = power + sums[y - 1][x] + sums[y][x - 1] - sums[y - 1][x - 1]
            }
        }
        
        var largestTotalPower: (upperLeft: (Int, Int), power: Int) = ((0,0), 0)
        for y in 3...300 {
            for x in 3...300 {
                let total = sums[y][x] - sums[y - 3][x] - sums[y][x - 3] + sums[y - 3][x - 3]
                if total > largestTotalPower.power {
                    largestTotalPower = (upperLeft: (x - 2, y - 2), power: total)
                }
            }
        }
        
        stageOneOutput = "\(largestTotalPower.upperLeft)"
        
        var largestSizedTotalPower: (upperLeft: (Int, Int), power: Int, size: Int) = ((0,0), 0, 0)
        for size in 1...300 {
            for y in size...300 {
                for x in size...300 {
                    let total = sums[y][x] - sums[y - size][x] - sums[y][x - size] + sums[y - size][x - size]
                    if total > largestSizedTotalPower.power {
                        largestSizedTotalPower = (upperLeft: (x - size + 1, y - size + 1), power: total, size: size)
                    }
                }
            }
        }
        
        stageTwoOutput = "\(largestSizedTotalPower.upperLeft)x\(largestSizedTotalPower.size)"
    }
}
