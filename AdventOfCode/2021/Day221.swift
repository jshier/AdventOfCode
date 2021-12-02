//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayTwo(_ output: inout DayOutput) async {
        let input = String.input(forDay: .two, year: .twentyOne)
//        let input = """
//        forward 5
//        down 5
//        forward 8
//        up 3
//        down 8
//        forward 2
//        """
        let movements = input.byLines().map(Movement.init)
        let finalPoint: Point = movements.reduce(.origin) { partialResult, movement in
            partialResult + movement.offset
        }
        output.stepOne = "\(finalPoint.product)"
        output.expectedStepOne = "1507611"

        let finalPosition: Position = movements.reduce(into: .init()) { partialResult, movement in
            switch movement.direction {
            case .down:
                partialResult.aim -= movement.distance
            case .up:
                partialResult.aim += movement.distance
            case .left, .right:
                partialResult.point += movement.offset
                partialResult.point += Point(0, partialResult.aim * movement.distance)
            }
        }

        output.stepTwo = "\(finalPosition.point.product)"
        output.expectedStepTwo = "1880593125"
    }
}

private struct Position {
    var point: Point = .origin
    var aim = 0
}

private struct Movement {
    let direction: Direction
    let distance: Int

    var offset: Point {
        Point(direction.forwardOffset.0 * distance, direction.forwardOffset.1 * distance)
    }

    init(_ string: String) {
        let parts = string.split(separator: " ")
        direction = {
            switch parts[0] {
            case "up": return .down
            case "down": return .up
            case "forward": return .right
            case "back": return .left
            default: fatalError()
            }
        }()
        distance = Int(parts[1])!
    }
}
