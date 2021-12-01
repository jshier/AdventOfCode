//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1220: Day {
    override var expectedStageOneOutput: String? { "364" }
    override var expectedStageTwoOutput: String? { "39518" }

    override func perform() async {
        let input = String.input(forDay: 12, year: 2020)
//        let input = """
//        F10
//        N3
//        F7
//        R90
//        F11
//        """

        enum Action {
            case forward(Int)
            case move(Direction, Int)
            case turn(Direction, Int)

            init(_ string: String) {
                let number = Int(string.dropFirst().suffix(3))!
                switch string.first {
                case "N":
                    self = .move(.up, number)
                case "S":
                    self = .move(.down, number)
                case "E":
                    self = .move(.right, number)
                case "W":
                    self = .move(.left, number)
                case "L":
                    self = .turn(.left, number / 90)
                case "R":
                    self = .turn(.right, number / 90)
                case "F":
                    self = .forward(number)
                default:
                    fatalError()
                }
            }
        }

        struct Ship {
            private(set) var position: Point = .origin
            private(set) var facing: Direction = .right

            mutating func apply(_ action: Action) {
                switch action {
                case let .forward(distance):
                    for _ in 0..<distance {
                        position += facing.forwardOffset
                    }
                case let .move(direction, distance):
                    for _ in 0..<distance {
                        position += direction.forwardOffset
                    }
                case let .turn(direction, times):
                    for _ in 0..<times {
                        facing = facing.turn(direction)
                    }
                }
            }
        }

        let actions = input.byLines().map(Action.init)
        var ship = Ship()
        actions.forEach { ship.apply($0) }

        stageOneOutput = "\(ship.position.manhattanDistance(to: .origin))"

        struct WaypointShip {
            private(set) var position: Point = .origin
            private var waypoint = Point(10, 1)

            mutating func apply(_ action: Action) {
                switch action {
                case let .forward(distance):
                    for _ in 0..<distance {
                        position += waypoint
                    }
                case let .move(direction, distance):
                    for _ in 0..<distance {
                        waypoint += direction.forwardOffset
                    }
                case let .turn(direction, times):
                    for _ in 0..<times {
                        waypoint = waypoint.rotated(direction)
                    }
                }
            }
        }

        var waypointShip = WaypointShip()
        actions.forEach { waypointShip.apply($0) }

        stageTwoOutput = "\(waypointShip.position.manhattanDistance(to: .origin))"
    }
}
