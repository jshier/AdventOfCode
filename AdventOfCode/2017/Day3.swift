//
//  Day3.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

extension TwentySeventeen {
    func dayThree(_ output: inout DayOutput) async {
        let input = 312_051

        let spiral = SquareSpiral()
        spiral.generate(outTo: input)

        output.stepOne = "\(spiral.distanceToOrigin)"
        output.expectedStepOne = "430"
        output.stepTwo = "\(spiral.firstLargerValue)"
        output.expectedStepTwo = "312453"
    }
}

private final class SquareSpiral {
    private var spiral: [Point] = [.origin]
    private var spiralValues: [Point: Int] = [.origin: 1]
    private var direction = Direction.right
    var firstLargerValue = 0

    func generate(outTo value: Int) {
        var sideLength = 1
        var previousPoint = spiral[0]
        while spiral.count <= value {
            for _ in 0..<2 {
                for _ in 0..<sideLength {
                    let point = previousPoint + direction.forwardOffset
                    spiral.append(point)

                    previousPoint = point

                    if firstLargerValue == 0 {
                        let newValue = point.surroundingPoints.map { spiralValues[$0] ?? 0 }.sum
                        if newValue > value {
                            firstLargerValue = newValue
                        } else {
                            spiralValues[point] = newValue
                        }
                    }
                }
                direction = direction.turn(.left)
            }
            sideLength += 1
        }

        spiral.removeLast(spiral.count - value)
    }

    var distanceToOrigin: Int {
        guard let lastPoint = spiral.last else { return 0 }

        return abs(lastPoint.x) + abs(lastPoint.y)
    }
}

extension SquareSpiral: CustomStringConvertible {
    var description: String {
        spiral.description
    }
}
