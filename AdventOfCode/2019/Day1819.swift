//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation
import SwiftGraph

final class Day1819: Day {
    override var expectedStageOneOutput: String? { nil }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() {
//        let input = String.input(forDay: 18, year: 2019)
        let input = """
        #########
        #b.A.@.a#
        #########
        """

        let lines = input.byLines()
        let byCharacter = lines.map { $0.map { $0 } }
        var navigablePoints: [Point: String] = [:]
        var keys: Set<Point> = []
        var doors: Set<Point> = []
        for y in 0..<lines.count {
            for x in 0..<lines[0].count {
                let character = byCharacter[y][x]

                guard character != "#" else { continue }

                let point = Point(x, y)
                let string = String(character)

                navigablePoints[point] = string

                if character.isLetter && character.isUppercase {
                    doors.insert(point)
                } else if character.isLetter && character.isLowercase {
                    keys.insert(point)
                }
            }
        }

        let atPoint = navigablePoints.first { $0.value == "@" }!.key
        let graph = WeightedGraph<Point, Int>(vertices: Array(navigablePoints.keys))

        func addPoints(adjacentTo point: Point) {
            let points = point.adjacentPoints.filter { navigablePoints.keys.contains($0) }
            for adjacentPoint in points {
                guard !graph.edgeExists(from: point, to: adjacentPoint) else { continue }

                graph.addEdge(from: point, to: adjacentPoint, weight: 1)
                addPoints(adjacentTo: adjacentPoint)
            }
        }

        addPoints(adjacentTo: atPoint)

        print(graph)

        // Find all routes from point to available keys
        // Filter any routes with a door
        // Remove destination key and door from their collections.
        // Repeat

        func findRoutes(from start: Point, keys: Set<Point>, doors: Set<Point>) -> [[WeightedGraph<Point, Int>.E]] {
            guard !keys.isEmpty && !doors.isEmpty else { return [] }

            let all = graph.findAllBfs(from: start) { keys.contains($0) }
            let doorIndices = Set(doors.compactMap { graph.indexOfVertex($0) })
            let available = all.filter { $0.count { doorIndices.contains($0.u) || doorIndices.contains($0.v) } == 0 }
            let availableKeyPoints = available.compactMap { $0.last?.v }.map { graph.vertexAtIndex($0) }
            // For each key point, start the process again.

            return available
        }

        let description = findRoutes(from: atPoint, keys: keys, doors: doors).map { $0.map { "\(graph.vertexAtIndex($0.u)) > \(graph.vertexAtIndex($0.v))" } }

        print(description)
    }
}
