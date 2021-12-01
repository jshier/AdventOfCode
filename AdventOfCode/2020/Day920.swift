//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day920: Day {
    override var expectedStageOneOutput: String? { "542529149" }
    override var expectedStageTwoOutput: String? { "75678618" }

    override func perform() async {
        let input = String.input(forDay: 9, year: 2020)
        let windowSize = 25
        let numbers = input.byLines().asInts()

        let invalidWindow = numbers.lazy
            .windows(ofCount: windowSize + 1)
            .first { window in
                !window.prefix(25).combinations(ofCount: 2).contains { $0.sum == window.last }
            }
        let invalidValue = invalidWindow!.last!

        stageOneOutput = "\(invalidValue)"

        let matchingWindow = (2..<numbers.count).lazy
            .compactMap { count in
                numbers.lazy.windows(ofCount: count).filter { $0.last! < invalidValue }.first { $0.sum == invalidValue }
            }
            .first

        let (min, max) = (matchingWindow!.min()!, matchingWindow!.max()!)

        stageTwoOutput = "\(min + max)"
        // 0.34263
    }
}
