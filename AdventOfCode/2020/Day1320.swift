//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1320: Day {
    override var expectedStageOneOutput: String? { "2238" }
    override var expectedStageTwoOutput: String? { "560214575859998" }

    override func perform() {
        let input = String.input(forDay: 13, year: 2020)
//        let input = """
//        939
//        7,13,x,x,59,x,31,19
//        """
        let lines = input.byLines()
        let earliestTime = Int(lines[0])!
        let busses = lines[1].byCommas().compactMap(Int.init)

        var foundBus = 0
        var time = earliestTime
        outer: while foundBus == 0 {
            for bus in busses {
                if time.isMultiple(of: bus) {
                    foundBus = bus
                    break outer
                }
            }
            time += 1
        }

        stageOneOutput = "\((time - earliestTime) * foundBus)"

        let indexedBusses = lines[1].byCommas().map { Int($0) ?? 1 }.indexed().filter { $1 != 1 }
        // Find n where n + index is a multiple of nextElement
        // Step is the multiple of the previous step and next value
        var commonTime = indexedBusses.first!.element
        var step = commonTime
        for pair in zip(indexedBusses, indexedBusses.dropFirst()) {
            let next = pair.1.element
            let nextIndex = pair.1.index
            while true {
                if (commonTime + nextIndex).isMultiple(of: next) {
                    break
                } else {
                    commonTime += step
                }
            }
            step = step * next
        }

        stageTwoOutput = "\(commonTime)"
    }
}
