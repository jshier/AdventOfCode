//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation
import SwiftGraph

final class Day1519: Day {
    override var expectedStageOneOutput: String? { "232" }
    override var expectedStageTwoOutput: String? { "320" }

    override func perform() async {
        let input = String.input(forDay: 15, year: 2019)
        let program = input.byCommas().asInts()
        let droid = RepairDroid(program: program)
        let oxygen = droid.findOxygenSystem()
        let edges = droid.movements.bfs(from: .origin, to: oxygen)

        stageOneOutput = "\(edges.count)"

        let farthestFromOxygen = droid.movements.dijkstra(root: oxygen, startDistance: 0).0.compactMap { $0 }.max()!

        stageTwoOutput = "\(farthestFromOxygen)"
    }

    final class RepairDroid {
        private(set) var map: [Point: Space] = [:]
        private let computer: IntcodeComputer
        let movements = WeightedGraph<Point, Int>()

        init(program: [Int]) {
            computer = IntcodeComputer(program: program, input: [], yieldForInput: true, yieldOnOutput: .yes(count: 1))
        }

        func findOxygenSystem() -> Point {
            var currentLocation = Point.origin
            _ = movements.addVertex(currentLocation)
            var currentDirection: Direction = .up

            while !computer.isHalted {
                switch computer.execute() {
                case .exited:
                    print("Exited.")
                    return currentLocation
                case .needInput:
                    computer.input.append(currentDirection.rawValue)
                    continue
                case .producedOutput:
                    let space = Space(rawValue: computer.outputs.removeFirst())!
                    let point = currentDirection.offset(currentLocation)
                    map[point] = space
                    switch space {
                    case .wall:
                        currentDirection = currentDirection.turn(.left)
                    case .empty, .oxygenSystem:
                        // Move to current location.
                        if !movements.vertices.contains(point) {
                            _ = movements.addVertex(point)
                            movements.addEdge(from: currentLocation, to: point, weight: 1)
                        }

                        currentLocation = point
                        currentDirection = currentDirection.turn(.right)
                    }
                case .crash: fatalError()
                }
                if currentLocation == .origin { break }
//                print(map, currentLocation: currentLocation)
            }

            return map.first { $0.value == .oxygenSystem }!.key
        }

        enum Space: Int {
            case wall, empty, oxygenSystem

            var output: String {
                switch self {
                case .wall: return "#"
                case .empty: return "."
                case .oxygenSystem: return "O"
                }
            }
        }
    }
}

func print(_ map: [Point: Day1519.RepairDroid.Space], currentLocation: Point) {
    let minX = map.keys.map { $0.x }.min()!
    let maxX = map.keys.map { $0.x }.max()!
    let minY = map.keys.map { $0.y }.min()!
    let maxY = map.keys.map { $0.y }.max()!

    var output = ""
    for y in (minY...maxY).reversed() {
        for x in minX...maxX {
            let point = Point(x, y)
            if point == Point(0, 0) {
                output += "X"
            } else if point == currentLocation {
                output += "D"
            } else {
                output += map[point]?.output ?? " "
            }
        }
        output += "\n"
    }
    print("---")
    print(output)
    print("---")
}
