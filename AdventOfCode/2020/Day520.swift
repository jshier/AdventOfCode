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
            let row = line.prefix(7).reduce((0, 127)) { result, character -> (Int, Int) in
                if character == "F" {
                    return (result.0, (result.1 - result.0) / 2 + result.0)
                } else {
                    let dividend = (Double(result.1 - result.0) / 2).rounded(.up)
                    return (Int(dividend) + result.0, result.1)
                }
            }
            let column = line.suffix(3).reduce((0, 7)) { result, character -> (Int, Int) in
                if character == "L" {
                    return (result.0, (result.1 - result.0) / 2 + result.0)
                } else {
                    let dividend = (Double(result.1 - result.0) / 2).rounded(.up)
                    return (Int(dividend) + result.0, result.1)
                }
            }
            return row.0 * 8 + column.0
        }.sorted()
        
        stageOneOutput = "\(seatIDs.max()!)"
        let seatID = zip(seatIDs, seatIDs.dropFirst()).first { $1 - $0 == 2 }!.0 + 1
        
        stageTwoOutput = "\(seatID)"
    }
}
