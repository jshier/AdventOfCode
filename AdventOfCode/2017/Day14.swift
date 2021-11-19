//
//  Day14.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/26/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day14: Day {
    override func perform() async {
        let fileInput = "hwlqcszp"
//        let testInput = "flqrgnkx"
        let input = fileInput
        let lines = (0..<128).map { "\(input)-\($0)" }
        let hashes = lines.map { $0.rawKnotHash() }
        let binaryStrings = hashes.map { $0.map { $0.paddedBinaryRepresentation }.joined() }
        let ones = binaryStrings.map { $0.count { $0 == "1" } }.reduce(0, +)

        stageOneOutput = "\(ones)"

        var points: Set<Point> = []
        for (y, line) in binaryStrings.enumerated() {
            for (x, character) in line.enumerated() {
                guard character == "1" else { continue }

                let currentPoint = Point(x, y)
                points.insert(currentPoint)
            }
        }

        func adjacentPoints(for localPoints: Set<Point>) -> Set<Point> {
            let adjacents = Set(localPoints.flatMap { $0.adjacentPoints })
            let containedPoints = points.intersection(adjacents)

            let newPoints = containedPoints.subtracting(localPoints)
            if newPoints.isEmpty {
                return localPoints
            } else {
                return adjacentPoints(for: localPoints.union(newPoints))
            }
        }

        var regions: Set<Set<Point>> = []
        var containedPoints: Set<Point> = []
        for point in points {
            guard !containedPoints.contains(point) else { continue }

            let adjacents = adjacentPoints(for: [point])
            regions.insert(adjacentPoints(for: [point]))
            adjacents.forEach { containedPoints.insert($0) }
        }

        stageTwoOutput = "\(regions.count)"
    }
}
