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
        
        func fuelRequired(for mass: Int) -> Int {
            var remainder = mass
            var sum = -remainder
            while remainder > 0 {
                sum += remainder
                remainder = (remainder / 3) - 2
            }
            
            return sum
        }
        
        let stage2Total = inputs.map(fuelRequired(for:)).reduce(0, +)
        stageTwoOutput = "\(stage2Total)"
    }
}
