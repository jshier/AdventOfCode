//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Algorithms
import Foundation

final class Day1020: Day {
    override var expectedStageOneOutput: String? { "2244" }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() {
//        let input = String.input(forDay: 10, year: 2020)
//        let input = """
//        16
//        10
//        15
//        5
//        1
//        11
//        7
//        19
//        6
//        12
//        4
//        """
        let input = """
        28
        33
        18
        42
        31
        14
        46
        20
        48
        47
        24
        23
        49
        45
        19
        38
        39
        11
        1
        32
        25
        35
        8
        17
        7
        9
        4
        2
        34
        10
        3
        """
        let adapters = input.byLines().asInts().sorted()
        let jolts = Array(chain(chain([0], adapters), [adapters.last! + 3]))
        
        let differences = zip(jolts, jolts.dropFirst()).map { $0.1 - $0.0 }
        
        let numberOfOnes = differences.count(of: 1)
        let numberOfThrees = differences.count(of: 3)
        print(Array(differences))

        stageOneOutput = "\(numberOfOnes * numberOfThrees)"
        
        // Reduce problem space.
        // All three difference locations must remain
        // For all sequences of 1s, how many combinations (1s, 2s, or 3s) are there.
        // Combinations of all 1s combinations multiplied together
        print([1, 1, 1, 1].combinations(ofCount: 2).count)
        let rangesOfOnes = differences.subranges(of: 1)
        let rangeLengthsOfTwoOrMore = rangesOfOnes.ranges.map { $0.count }.filter { $0 >= 2 }
        let numberOfPossibleTwos = rangeLengthsOfTwoOrMore.map { $0 - 1 }
        let numberOfPossibleThrees = rangeLengthsOfTwoOrMore.map { $0 - 2 }
        let twosAndThrees = zip(numberOfPossibleTwos, numberOfPossibleThrees).map { $0.0 + $0.1 }
        let combinations = twosAndThrees.map { $0 + 1 }.reductions(*)
        // Original(1) + possible twos + possible threes Product of combinations with ranges,
        // 1 1 1, 2 1, 1 2, 3 || 1 1, 2
        // 111, 21, 12 = ( 3 | 2)
        // 1111, 211, 112, 121, 22 = (4 | 4)
        // 11111, 2111, 1211, 1121, 1112, 221, 212, 122 (5 | 7)
        
        print(combinations)
    }
}
