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
//        let input = """
//        #########
//        #b.A.@.a#
//        #########
//        """
//        let input = """
//        ########################
//        #f.D.E.e.C.b.A.@.a.B.c.#
//        ######################.#
//        #d.....................#
//        ########################
//        """
//        let input = """
//        ########################
//        #...............b.C.D.f#
//        #.######################
//        #.....@.a.B.c.d.A.e.F.g#
//        ########################
//        """
        let input = """
        #################
        #i.G..c...e..H.p#
        ########.########
        #j.A..b...f..D.o#
        ########@########
        #k.E..a...g..B.n#
        ########.########
        #l.F..d...h..C.m#
        #################
        """

        let lines = input.byLines()
        let byCharacter = lines.map { $0.map { $0 } }
        var navigablePoints: [Point: String] = [:]
        var keys: Set<Point> = []
        var doors: [String: Point] = [:]
        for y in 0..<lines.count {
            for x in 0..<lines[0].count {
                let character = byCharacter[y][x]

                guard character != "#" else { continue }

                let point = Point(x, y)
                let string = String(character)

                navigablePoints[point] = string

                if character.isLetter && character.isUppercase {
                    doors[string] = point
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

        let allPaths: [Point: [Point: [WeightedGraph<Point, Int>.E]]] = keys.reduce(into: [:]) { output, element in
            let pathsToOtherKeys: [Point: [WeightedGraph<Point, Int>.E]] = keys.subtracting([element]).reduce(into: [:]) { subOutput, subElement in
                subOutput[subElement] = graph.bfs(from: element, to: subElement)
            }
            output[element] = pathsToOtherKeys
        }

//        print(graph)

        // Find all routes from point to available keys
        // Filter any routes with a door
        // Remove destination key and door from their collections.
        // Repeat

//        func findRoutes(from start: Point,
//                        keepingPath path: [WeightedGraph<Point, Int>.E],
//                        keys: Set<Point>,
//                        doors: [String: Point]) -> [[WeightedGraph<Point, Int>.E]] {
//            guard !keys.isEmpty || !doors.isEmpty else { return [path] }
//
//            let all = graph.findAllBfs(from: start) { keys.contains($0) }
//            let doorIndices = Set(doors.values.compactMap { graph.indexOfVertex($0) })
//            let available = all.filter { $0.count { doorIndices.contains($0.u) || doorIndices.contains($0.v) } == 0 }
//            let availableKeyPoints = available.compactMap { $0.last?.v }.map { graph.vertexAtIndex($0) }
//            let remainingPaths: [[[WeightedGraph<Point, Int>.E]]] = zip(available, availableKeyPoints).map { input in
//                let (newPath, keyPoint) = input
//                let key = navigablePoints[keyPoint]!
//                let door = key.uppercased()
//                let newKeys = keys.subtracting([keyPoint])
//                var newDoors = doors
//                newDoors.removeValue(forKey: door)
//                let additionalRoutes = findRoutes(from: keyPoint, keepingPath: newPath, keys: newKeys, doors: newDoors)
//
//                return additionalRoutes
//            }
//            // For each key point, start the process again.
//            let allPaths = remainingPaths.flatMap { $0 }
//            let fullPaths = allPaths.map { path + $0 }
//
//            return fullPaths
//        }
//
//        let routes = findRoutes(from: atPoint, keepingPath: [], keys: keys, doors: doors)
        ////        let description = routes.map { $0.map { "\(graph.vertexAtIndex($0.u)) > \(graph.vertexAtIndex($0.v))" } }
//        let shortestRoute = routes.min { $0.count < $1.count } ?? []
//        let shortestKeys = shortestRoute
//            .map { graph.vertexAtIndex($0.v) }
//            .compactMap { navigablePoints[$0] }
//            .filter { Character($0).isLowercase }
//            .reduce(into: [String]()) { if !$0.contains($1) { $0.append($1) } }
//            .joined(separator: ", ")
//
//        print(shortestKeys)
//        print(shortestRoute.count)
    }
}
