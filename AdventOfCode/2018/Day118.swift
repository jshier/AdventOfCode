//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day118: Day {
    override func perform() {
        let input = String.input(forDay: 1)
        let lines = input.split(separator: "\n").map(String.init)
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


