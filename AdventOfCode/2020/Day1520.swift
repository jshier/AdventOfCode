//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1520: Day {
    override var expectedStageOneOutput: String? { "475" }
    override var expectedStageTwoOutput: String? { "11261" }

    override func perform() async {
        let input = String.input(forDay: 15, year: 2020)
//        let input = "0,3,6"
        let numbers = input.byCommas().compactMap(Int.init)

        struct Game {
            private let numbers: [Int]
            var spoken: [Int] = []

            init(_ numbers: [Int]) {
                self.numbers = numbers
            }

            mutating func play(untilTurn maxTurns: Int) -> Int {
                spoken = Array(repeating: 0, count: maxTurns)
                numbers.indexed().forEach { spoken[$0.1] = $0.0 + 1 }
                var last = numbers.last!
                for turn in numbers.count..<maxTurns {
                    let previous = spoken[last]
                    let value = (previous == 0) ? 0 : turn - spoken[last]
                    spoken[last] = turn
                    last = value
                }

                return last
            }
        }

        var stageOneGame = Game(numbers)

        stageOneOutput = "\(stageOneGame.play(untilTurn: 2020))"

        var stageTwoGame = Game(numbers)

        stageTwoOutput = "\(stageTwoGame.play(untilTurn: 30_000_000))"
    }
}
