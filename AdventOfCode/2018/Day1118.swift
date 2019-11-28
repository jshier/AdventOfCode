//
//  Day1018.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/10/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1118: Day {
    override var expectedStageOneOutput: String? { "(19, 41)" }
    override var expectedStageTwoOutput: String? { "(237, 284)x11" }
    
    override func perform() {
        let input = 5535
        
        var grid: [Point: Int] = [:]
        for point in PointSequence(start: Point(1,1), end: Point(300,300)) {
            let rackID = point.x + 10
            var powerLevel = rackID * point.y
            powerLevel += input
            powerLevel *= rackID
            let hundreds = (powerLevel / 100) % 10
            grid[point] = (hundreds - 5)
        }
        
        var largestTotalPower: (upperLeft: Point, power: Int) = (Point(0,0), 0)
        for upperLeft in PointSequence(start: Point(1,1), end: Point(298, 298)) {
            var totalPower = 0
            for point in PointSequence(start: upperLeft, end: Point(upperLeft.x + 2, upperLeft.y + 2)) {
                totalPower += (grid[point] ?? 0)
            }
            if totalPower > largestTotalPower.power { largestTotalPower = (upperLeft: upperLeft, power: totalPower) }
        }
        
        stageOneOutput = "\(largestTotalPower.upperLeft)"
        
        struct GridPower {
            let upperLeft: Point
            let power: Int
            let size: Int
            
            var position: String { "\(upperLeft)x\(size)" }
        }
        
        let positionalPower = grid.keys.map { (newKey: "\($0)x1", originalKey: $0) }
        var gridPowers: [String: Int] = positionalPower.reduce(into: [:]) { (result, element) in
            result[element.newKey] = grid[element.originalKey]
        }
        var largestGridTotalPower = GridPower(upperLeft: Point(0,0), power: 0, size: 0)
        for size in 2...300 {
            for upperLeft in PointSequence(start: Point(1,1), end: Point(300 - (size - 1), 300 - (size - 1))) {
                guard var totalPower = gridPowers["\(upperLeft)x\(size - 1)"] else {
                    fatalError("No cached grid found!")
                }
                
                for x in upperLeft.x..<(upperLeft.x + size) {
                    totalPower += (grid[Point(x, upperLeft.y + (size - 1))] ?? 0)
                }
                
                for y in upperLeft.y..<(upperLeft.y + (size - 1)) {
                    totalPower += (grid[Point(upperLeft.x + (size - 1), y)] ?? 0)
                }
                
                gridPowers["\(upperLeft)x\(size)"] = totalPower
                
                if totalPower > largestGridTotalPower.power {
                    largestGridTotalPower = GridPower(upperLeft: upperLeft, power: totalPower, size: size)
                }
            }
        }
        
        stageTwoOutput = largestGridTotalPower.position
    }
}
