//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1719: Day {
    override var expectedStageOneOutput: String? { nil }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() {
        let input = String.input(forDay: 17, year: 2019)
        let program = input.byCommas().asInts()
        let bot = Bot(program: program)
        let calibrationValue = bot.calibrate()

        stageOneOutput = "\(calibrationValue)"
    }

    final class Bot {
        private let brain: IntcodeComputer

        init(program: [Int]) {
            brain = IntcodeComputer(program: program,
                                    input: [],
                                    yieldForInput: true,
                                    yieldOnOutput: .no)
        }

        func calibrate() -> Int {
            var output = ""
            loop: while !brain.isHalted {
                switch brain.execute() {
                case .exited:
//                    print("Exited")
                    break loop
                case .needInput:
//                    print("Needs input.")
                    break loop
                case .producedOutput:
                    print(brain.outputs)
                    output.append(Character(.init(UInt8(brain.output!))))
//                    print("Produced output: \(brain.output!)")
//                    break loop
                case .crash: print("Crash"); break loop
                }
            }
            let scalars = brain.outputs.map(UInt8.init).map(Unicode.Scalar.init)
            let strings = scalars.map(String.init)
            let lines = strings.joined().byLines().map { $0.chunked(into: 1) }

            var intersections: [Point] = []
            for lineNumber in 1..<(lines.count - 1) {
                for characterNumber in 1..<(lines[1].count - 1) {
                    guard lines[lineNumber][characterNumber] == "#" else { continue }

                    if [lines[lineNumber][characterNumber - 1],
                        lines[lineNumber][characterNumber + 1],
                        lines[lineNumber - 1][characterNumber],
                        lines[lineNumber + 1][characterNumber]].allSatisfy({ $0 == "#" }) {
                        intersections.append(Point(characterNumber, lineNumber))
                    }
                }
            }

//            print(strings.joined())
            return intersections.map { $0.x * $0.y }.reduce(0, +)
        }
    }
}
