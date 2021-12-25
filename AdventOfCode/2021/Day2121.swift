//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Algorithms

extension TwentyTwentyOne {
    func dayTwentyOne(input: String, output: inout DayOutput) async {
        let p1Start = 7
        let p2Start = 0
//        let p1Start = 3
//        let p2Start = 7
        var p1Position = p1Start
        var p2Position = p2Start
        var p1Score = 0
        var p2Score = 0
        var rolls = 0
        for values in Array(1...100).cycled(times: 100).chunks(ofCount: 6) {
            let values = Array(values)
            let p1Values = values[..<3]
            let p2Values = values[3...]
            p1Position = (p1Position + p1Values.sum) % 10
            p1Score += p1Position + 1
            rolls += 3

            if p1Score >= 1000 {
                break
            }

            p2Position = (p2Position + p2Values.sum) % 10
            p2Score += p2Position + 1
            rolls += 3

            if p2Score >= 1000 {
                break
            }
        }

        output.stepOne = "\(rolls * min(p1Score, p2Score))"
        output.expectedStepOne = "518418"

        struct State: Hashable {
            let p1: Int
            let p2: Int
            let s1: Int
            let s2: Int
        }

//        let sumMultiples = [(3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1)]
        let sumMultiples = [3: 1, 4: 3, 5: 6, 6: 7, 7: 6, 8: 3, 9: 1]
        var cache: [State: (Int, Int)] = [:]

        func countWins(fromPosition1 p1: Int, position2 p2: Int, score1: Int, score2: Int) -> (Int, Int) {
            if score1 >= 21 { return (1, 0) }
            if score2 >= 21 { return (0, 1) }

            let state = State(p1: p1, p2: p2, s1: score1, s2: score2)
            if let result = cache[state] {
                return result
            }

            var result = (0, 0)
            for (sum, multiple) in sumMultiples {
                let newP1 = (p1 + sum) % 10
                let newScore1 = score1 + newP1 + 1

                let (x1, y1) = countWins(fromPosition1: p2, position2: newP1, score1: score2, score2: newScore1)
                result = (result.0 + (y1 * multiple), result.1 + (x1 * multiple))
            }
            cache[state] = result
            return result
        }

        let result = countWins(fromPosition1: p1Start, position2: p2Start, score1: 0, score2: 0)
        output.stepTwo = "\(max(result.0, result.1))"
        output.expectedStepTwo = "116741133558209"
    }
}
