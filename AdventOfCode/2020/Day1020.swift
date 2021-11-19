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
    override var expectedStageTwoOutput: String? { "3947645370368" }

    override func perform() async {
        let input = String.input(forDay: 10, year: 2020)
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
//        let input = """
//        28
//        33
//        18
//        42
//        31
//        14
//        46
//        20
//        48
//        47
//        24
//        23
//        49
//        45
//        19
//        38
//        39
//        11
//        1
//        32
//        25
//        35
//        8
//        17
//        7
//        9
//        4
//        2
//        34
//        10
//        3
//        """
        let adapters = input.byLines().asInts().sorted()
        let jolts = [0] + adapters + [adapters[adapters.count - 1] + 3]

        let differences = zip(jolts, jolts.dropFirst()).map { $0.1 - $0.0 }

        let numberOfOnes = differences.count(of: 1)
        let numberOfThrees = differences.count(of: 3)

        stageOneOutput = "\(numberOfOnes * numberOfThrees)"

        let rangesOfOnes = differences.subranges(of: 1)
        let rangeLengths = rangesOfOnes.ranges.map(\.count)
        let fives = rangeLengths.count(of: 5)
        precondition(fives == 0)
        let fours = rangeLengths.count(of: 4)
        let threes = rangeLengths.count(of: 3)
        let twos = rangeLengths.count(of: 2)
        
        stageTwoOutput = "\(pow(7, fours) * pow(4, threes) * pow(2, twos))"
    }
}
