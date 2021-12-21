//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func daySeventeen(input: String, output: inout DayOutput) async {
        let area = Area(input.dropFirst(13))
        let calculatedMaxHeight = (area.minY * (area.minY + 1)) / 2

        output.stepOne = "\(calculatedMaxHeight)"
        output.expectedStepOne = "5151"

        func triangle(_ k: Int) -> Int {
            k * (k + 1) / 2
        }

        func xDistance(dx: Int, steps: Int) -> Int {
            triangle(dx) - triangle(max(0, dx - steps))
        }

        var minDx = area.minX - 1
        var maxDx = area.maxX

        var inRange = 0

        for initialDy in area.minY...(-area.minY) {
            var dy = initialDy < 0 ? initialDy : -initialDy - 1
            var y = 0
            var minVisited = Int.max

            for step in (initialDy < 0 ? 1 : 2 * initialDy + 2)... {
                y += dy
                dy -= 1

                if y < area.minY {
                    break
                }

                if y <= area.maxY {
                    while xDistance(dx: minDx, steps: step) >= area.minX {
                        minDx -= 1
                    }

                    while xDistance(dx: maxDx, steps: step) > area.maxX {
                        maxDx -= 1
                    }

                    inRange += min(maxDx, minVisited) - minDx
                    minVisited = minDx
                }
            }
        }

        output.stepTwo = "\(inRange)"
        output.expectedStepTwo = "968"
    }
}

private struct Area {
    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int

    init<S>(_ string: S) where S: StringProtocol {
        let xy = string.components(separatedBy: ", ").map { $0.dropFirst(2).components(separatedBy: "..") }
        minX = Int(xy[0][0])!
        maxX = Int(xy[0][1])!
        minY = Int(xy[1][0])!
        maxY = Int(xy[1][1])!
    }

    func contains(_ point: Point) -> Bool {
        point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
    }
}
