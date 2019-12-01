//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day119: Day {
    override var expectedStageOneOutput: String? { "3269199" }
    override var expectedStageTwoOutput: String? { "4900909" }
    
    override func perform() {
        let input = String.input(forDay: 1, year: 2019)
        let inputs = input.byLines().compactMap(Int.init)
        let values = inputs.map { ($0 / 3) - 2 }
        let total = values.reduce(0, +)

        stageOneOutput = "\(total)"
        
        func fuelRequired(forTotal total: Int, nextMass mass: Int) -> Int {
            let latest = (mass / 3) - 2

            return (latest > 0) ? fuelRequired(forTotal: total + latest, nextMass: latest) : total
        }
        
        let stage2Total = inputs.reduce(0, fuelRequired(forTotal:nextMass:))

        stageTwoOutput = "\(stage2Total)"
    }
}
