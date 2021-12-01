//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day120: Day {
    override var expectedStageOneOutput: String? { "326211" }
    override var expectedStageTwoOutput: String? { "131347190" }

    override func perform() async {
        let input = String.input(forDay: 1, year: 2020)
        let ints = Set(input.byLines().asInts())
        let pairsProduct = ints
            .first { ints.contains(2020 - $0) }
            .map { $0 * (2020 - $0) }!

        stageOneOutput = "\(pairsProduct)"

        let tripleProduct = ints
            .lazy
            .combinations(ofCount: 2)
            .first { ints.contains(2020 - $0.sum) }
            .map { $0.product() * (2020 - $0.sum) }!

        stageTwoOutput = "\(tripleProduct)"
    }
}
