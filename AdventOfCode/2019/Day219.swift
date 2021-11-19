//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day219: Day {
    override var expectedStageOneOutput: String? { "4930687" }
    override var expectedStageTwoOutput: String? { "5335" }

    override func perform() async {
        let input = String.input(forDay: 2, year: 2019)
        let values = input.byCommas().asInts()

        var stageOneMemory = values
        stageOneMemory[1] = 12
        stageOneMemory[2] = 2
        outer: for i in stride(from: 0, to: stageOneMemory.count, by: 4) {
            switch stageOneMemory[i] {
            case 1:
                stageOneMemory[stageOneMemory[i + 3]] = stageOneMemory[stageOneMemory[i + 1]] + stageOneMemory[stageOneMemory[i + 2]]
            case 2:
                stageOneMemory[stageOneMemory[i + 3]] = stageOneMemory[stageOneMemory[i + 1]] * stageOneMemory[stageOneMemory[i + 2]]
            case 99:
                break outer
            default:
                print("Broken")
                break outer
            }
        }

        stageOneOutput = "\(stageOneMemory[0])"

        let expectedOutput = 19_690_720
        var stageTwoMemory = values
        var output = 0
        outer: for noun in 0...99 {
            for verb in 0...99 {
                stageTwoMemory = values
                stageTwoMemory[1] = noun
                stageTwoMemory[2] = verb
                program: for i in stride(from: 0, to: stageTwoMemory.count, by: 4) {
                    switch stageTwoMemory[i] {
                    case 1:
                        stageTwoMemory[stageTwoMemory[i + 3]] = stageTwoMemory[stageTwoMemory[i + 1]] + stageTwoMemory[stageTwoMemory[i + 2]]
                    case 2:
                        stageTwoMemory[stageTwoMemory[i + 3]] = stageTwoMemory[stageTwoMemory[i + 1]] * stageTwoMemory[stageTwoMemory[i + 2]]
                    case 99:
                        break program
                    default:
                        print("Broken")
                        break program
                    }
                }

                if stageTwoMemory[0] == expectedOutput {
                    output = 100 * noun + verb
                    break outer
                }
            }
        }

        stageTwoOutput = "\(output)"
    }
}
