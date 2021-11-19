//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day319: Day {
    override var expectedStageOneOutput: String? { "280" }
    override var expectedStageTwoOutput: String? { "10554" }

    override func perform() async {
        let input = String.input(forDay: 3, year: 2019)
        let wires = input.byLines()

        struct Path {
            let direction: Direction
            let distance: Int

            init(_ value: String) {
                var value = value
                let direction = value.removeFirst()
                switch direction {
                case "U": self.direction = .up
                case "D": self.direction = .down
                case "L": self.direction = .left
                case "R": self.direction = .right
                default: fatalError()
                }
                distance = Int(value)!
            }
        }

        let first = wires[0].byCommas().map(Path.init)
        let second = wires[1].byCommas().map(Path.init)

        var firstPoints: [Point] = [Point(0, 0)]
        for path in first {
            for _ in 0..<path.distance {
                firstPoints.append(firstPoints[firstPoints.count - 1] + path.direction.forwardOffset)
            }
        }
        firstPoints = Array(firstPoints.dropFirst())

        var secondPoints: [Point] = [Point(0, 0)]
        for path in second {
            for _ in 0..<path.distance {
                secondPoints.append(secondPoints[secondPoints.count - 1] + path.direction.forwardOffset)
            }
        }
        secondPoints = Array(secondPoints.dropFirst())

        let firstUnique = Set(firstPoints)
        let secondUnique = Set(secondPoints)
        let commonPoints = firstUnique.intersection(secondUnique)
        let distances: [Point: Int] = commonPoints.reduce(into: [:]) { result, nextPoint in
            result[nextPoint] = nextPoint.manhattanDistance(to: Point(0, 0))
        }

        let min = distances.min { $0.value < $1.value }

        stageOneOutput = "\(min!.value)"

        var numberOfStepsToIntersection: [Point: (Int, Int)] = [:]
        for point in commonPoints {
            let firstIndex = firstPoints.firstIndex(of: point)!
            let secondIndex = secondPoints.firstIndex(of: point)!
            numberOfStepsToIntersection[point] = (firstIndex, secondIndex)
        }

        let minimumDistance = numberOfStepsToIntersection.min { ($0.value.0 + $0.value.1) < ($1.value.0 + $1.value.1) }

        stageTwoOutput = "\(minimumDistance!.value.0 + minimumDistance!.value.1 + 2)"
    }
}
