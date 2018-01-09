//
//  Day315.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day315: Day {
    override func perform() {
        let fileInput = String.input(forDay: 3, year: 2015)
//        let testInput = "^>v<"
        let input = fileInput
        let directions = input.map(Direction.init)
        
        var deliveryMap: [Point : Int] = [Point(0, 0) : 1]
        var currentPoint = Point(0, 0)
        for direction in directions {
            currentPoint += direction.forwardOffset
            deliveryMap[currentPoint, default: 0] += 1
        }
        
        stageOneOutput = "\(deliveryMap.values.count { $0 >= 1 })"
        
        var roboMap: [Point: Int] = [:]
        var santaPoint = Point(0, 0)
        var roboPoint = santaPoint
        for index in stride(from: 0, to: directions.count, by: 2) {
            santaPoint += directions[index].forwardOffset
            roboMap[santaPoint, default: 0] += 1
            roboPoint += directions[index + 1].forwardOffset
            roboMap[roboPoint, default: 0] += 1
        }
        
        stageTwoOutput = "\(roboMap.values.count { $0 >= 1 })"
    }
}

extension Direction {
    init(_ character: Character) {
        switch character {
        case "^": self = .up
        case "v": self = .down
        case "<": self = .left
        case ">": self = .right
        default: fatalError()
        }
    }
}
