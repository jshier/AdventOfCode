//
//  Day315.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

extension TwentyFifteen {
    func dayThree(_ output: inout DayOutput) async {
        let fileInput = String.input(forDay: .three, year: .fifteen)
//        let testInput = "^>v<"
        let input = fileInput
        let directions = input.map(Direction.init)

        var deliveryMap: [Point: Int] = [Point(0, 0): 1]
        var currentPoint = Point(0, 0)
        for direction in directions {
            currentPoint += direction.forwardOffset
            deliveryMap[currentPoint, default: 0] += 1
        }

        output.stepOne = "\(deliveryMap.values.count { $0 >= 1 })"
        output.expectedStepOne = "2081"

        var roboMap: [Point: Int] = [:]
        var santaPoint = Point(0, 0)
        var roboPoint = santaPoint
        for index in directions.indices.striding(by: 2) {
            santaPoint += directions[index].forwardOffset
            roboMap[santaPoint, default: 0] += 1
            roboPoint += directions[index + 1].forwardOffset
            roboMap[roboPoint, default: 0] += 1
        }

        output.stepTwo = "\(roboMap.values.count { $0 >= 1 })"
        output.expectedStepTwo = "2341"
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
