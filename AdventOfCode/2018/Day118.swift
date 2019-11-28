//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day118: Day {
    override var expectedStageOneOutput: String? { "425" }
    override var expectedStageTwoOutput: String? { "57538" }
    
    override func perform() {
        let input = String.input(forDay: 1, year: 2018)
        let lines = input.byLines()
        let frequencies = lines.compactMap(Int.init)
        let initialSum = frequencies.reduce(0, +)
        stageOneOutput = "\(initialSum)"
        var seen: Set<Int> = []
        var duplicateValue: Int?
        var accumulate = 0
        seen.insert(accumulate)
        for number in frequencies.cycle() {
            accumulate += number
            if seen.contains(accumulate) { duplicateValue = accumulate; break }
            seen.insert(accumulate)
        }
        
        stageTwoOutput = "\(duplicateValue.map(String.init) ?? "NoneFound")"
    }
}
