//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import SwiftGraph

extension TwentyTwentyOne {
    func dayFifteen(input: String, output: inout DayOutput) async {
//        let input = """
//        1163751742
//        1381373672
//        2136511328
//        3694931569
//        7463417111
//        1319128137
//        1359912421
//        3125421639
//        1293138521
//        2311944581
//        """
        let input = "8"
        let cavern = Grid(input.byLines().map { $0.asInts() })
        let destination = Array(cavern.points).last!

//        func findLowRiskPath(startingAt startingPoint: Point, alreadySeen: Set<Point>)
//
//        var currentPoint = Point.origin
//        let destination = Array(cavern.points).last
//        var seenPoints: Set<Point> = [.origin]
//        var totalCost = 0
//        while currentPoint != destination {
//            let adjacents = cavern.adjacentPoints(for: currentPoint)
//            let cheapest = adjacents
//                .map { (point: $0, cost: cavern[$0]) }
//                .filter { !seenPoints.contains($0.point) }
//                .min { $0.cost < $1.cost }!
//            totalCost += cheapest.cost
//            currentPoint = cheapest.point
//            seenPoints.insert(currentPoint)
//            print(currentPoint)
//        }
//
//        print(totalCost)
//        let graph = WeightedGraph<Point, Int>()
//        for point in cavern.points {
//            _ = graph.addVertex(point)
//            for adjacent in cavern.adjacentPoints(for: point) {
//                graph.addVertex(adjacent)
//                graph.addEdge(from: point, to: adjacent, weight: cavern[adjacent], directed: true)
//                graph.addEdge(from: adjacent, to: point, weight: cavern[point], directed: true)
//            }
//        }
//        let (distances, paths) = graph.dijkstra(root: .origin, startDistance: 0)
//        let pointDistances = distanceArrayToVertexDict(distances: distances, graph: graph)
//        let destinationIndex = graph.indexOfVertex(destination)!
//        let shorted = distances[destinationIndex]
//        print(shorted!)
        // lol, takes 571 seconds.
//        let path = cavern.findPath(from: .origin, to: destination)
//        print(path.map { cavern[$0] }.sum - cavern[.origin])

//        let horizontalRepeats: [[Int]] = cavern.values.reduce(into: Array(repeating: [], count: 5)) { partialResult, value in
//            for i in 0..<5 {
//                var possible = value + i
//                if possible > 9 {
//                    possible = possible - 9
//                }
//                partialResult[i].append(possible)
//            }
//        }
//        let horizontal: [Int] = horizontalRepeats
//        print(horizontalRepeats)
        let repeats: [Point: Int] = cavern.points.reduce(into: [:]) { partialResult, point in
            for i in 0..<5 {
                // original x, original y, neither
                let xPoint = (i * cavern.width) + point.x
                let yPoint = (i * cavern.height) + point.y
                var value = cavern[point] + i
                if value > 9 {
                    value -= 9
                }
                partialResult[Point(xPoint, point.y)] = value
                partialResult[Point(point.x, yPoint)] = value
            }
        }
        print(repeats)
    }
}
