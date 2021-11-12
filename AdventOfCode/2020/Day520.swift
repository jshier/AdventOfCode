//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day520: Day {
    override var expectedStageOneOutput: String? { "987" }
    override var expectedStageTwoOutput: String? { "603" }

    override func perform() {
        let input = String.input(forDay: 5, year: 2020)
//        let input = """
//        FBFBBFFRLR
//        """
//        let input = """
//        BFFFBBFRRR
//        FFFBBBFRRR
//        BBFFBBFRLL
//        """
        let passes = input.byLines()
        let seatIDs: [Int] = passes.map { line in
            let row = line.prefix(7).reversed().enumerated().reduce(0) { ($1.1 == "B") ? ($0 | 1 << $1.0) : $0 }
            let column = line.suffix(3).reversed().enumerated().reduce(0) { ($1.1 == "R") ? ($0 | 1 << $1.0) : $0 }
            return row * 8 + column
        }
        .sorted()

        stageOneOutput = "\(seatIDs.max()!)"

        let seatID = zip(seatIDs, seatIDs.dropFirst()).first { $1 - $0 == 2 }!.0 + 1

        stageTwoOutput = "\(seatID)"
    }
}
