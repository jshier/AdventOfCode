//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1919: Day {
    override var expectedStageOneOutput: String? { "114" }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() {
        let input = String.input(forDay: 19, year: 2019)
        let program = input.byCommas().asInts()
        let drone = Drone(program: program)
        let affectedPoints = drone.testTractor()

        stageOneOutput = "\(affectedPoints.count)"

        let output = affectedPoints.print {
            $0 ? "#" : "."
        }

        print(output)
    }

    final class Drone {
        private let brain: IntcodeComputer

        init(program: [Int]) {
            brain = IntcodeComputer(program: program, input: [], yieldForInput: true, yieldOnOutput: .yes(count: 1))
        }

        func testTractor() -> [Point] {
            var result: [Point] = []
            for y in 0..<50 {
                var seenForThisLine = false
                var leftMost = 0
                line: for x in leftMost..<50 {
                    let point = Point(x, y)
                    loop: while !brain.isHalted {
                        switch brain.execute() {
                        case .needInput:
                            brain.input.append(contentsOf: [point.x, point.y])
                        case .producedOutput:
                            if brain.output == 1 {
                                result.append(point)

                                if !seenForThisLine {
                                    seenForThisLine = true
                                    leftMost = x
                                }
                            } else {
                                if seenForThisLine {
                                    brain.outputs.removeAll(keepingCapacity: true)
                                    brain.reset()
                                    break line
                                }
                            }
                            brain.outputs.removeAll(keepingCapacity: true)
                            break loop
                        case .exited: continue // print("Exited.")
                        case .crash: print("Crash.")
                        }
                    }
                    //                print("reset")
                    brain.reset()
                }
//                print("Line: \(y)")
            }

            return result
        }
    }
}
