//
//  Day3.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

class Day3: Day {
    override func perform() {
        let input = 312051
        var square = 1
        var odd = 1
        while square < input {
            square = odd * odd
            odd += 2
        }

        let center = (odd - 1) / 2
        let closestCenter = square - center
        let centerDifference = closestCenter - input
        let horizontalCoordinate = (closestCenter <= input) ? centerDifference : -centerDifference
        let verticalCoordinate = center
        let steps = abs(horizontalCoordinate) + abs(verticalCoordinate)
        print("Day 3: \(steps)")
    }
}
