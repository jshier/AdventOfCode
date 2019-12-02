//
//  Day1018.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/10/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1018: Day {
    override func perform() {
        let input = String.input(forDay: 10, year: 2018)
//        let input = """
//                    position=< 9,  1> velocity=< 0,  2>
//                    position=< 7,  0> velocity=<-1,  0>
//                    position=< 3, -2> velocity=<-1,  1>
//                    position=< 6, 10> velocity=<-2, -1>
//                    position=< 2, -4> velocity=< 2,  2>
//                    position=<-6, 10> velocity=< 2, -2>
//                    position=< 1,  8> velocity=< 1, -1>
//                    position=< 1,  7> velocity=< 1,  0>
//                    position=<-3, 11> velocity=< 1, -2>
//                    position=< 7,  6> velocity=<-1, -1>
//                    position=<-2,  3> velocity=< 1,  0>
//                    position=<-4,  3> velocity=< 2,  0>
//                    position=<10, -3> velocity=<-1,  1>
//                    position=< 5, 11> velocity=< 1, -2>
//                    position=< 4,  7> velocity=< 0, -1>
//                    position=< 8, -2> velocity=< 0,  1>
//                    position=<15,  0> velocity=<-2,  0>
//                    position=< 1,  6> velocity=< 1,  0>
//                    position=< 8,  9> velocity=< 0, -1>
//                    position=< 3,  3> velocity=<-1,  1>
//                    position=< 0,  5> velocity=< 0, -1>
//                    position=<-2,  2> velocity=< 2,  0>
//                    position=< 5, -2> velocity=< 1,  2>
//                    position=< 1,  4> velocity=< 2,  1>
//                    position=<-2,  7> velocity=< 2, -2>
//                    position=< 3,  6> velocity=<-1, -1>
//                    position=< 5,  0> velocity=< 1,  0>
//                    position=<-6,  0> velocity=< 2,  0>
//                    position=< 5,  9> velocity=< 1, -2>
//                    position=<14,  7> velocity=<-2,  0>
//                    position=<-3,  6> velocity=< 2, -1>
//                    """
        let stars = Stars(input)
        stars.simulateUntilText()
        print(stars)
    }

    final class Stars {
        var stars: [Star]
        var time = 0

        init(_ string: String) {
            stars = string.byLines().map(Star.init).sorted { $0.position < $1.position }
        }

        func simulateUntilText() {
            var keepGoing = true
            var minHeight = Int.max
            while keepGoing {
                let newStars = stars.map { Star(position: $0.position + $0.velocity, velocity: $0.velocity) }
                let maxX = newStars.max { $0.position.x < $1.position.x }!.position.x
                let minX = newStars.min { $0.position.x < $1.position.x }!.position.x
                let lastHeight = maxX - minX
                if lastHeight < minHeight {
                    minHeight = lastHeight
                    stars = newStars
                    time += 1
                } else {
                    keepGoing = false
                }
            }
        }
    }
}

extension Day1018.Stars: CustomStringConvertible {
    var description: String {
        let positions = stars.map { $0.position }.sorted()
        let largestY = positions.map { $0.y }.max()!
        let furthestPoint = Point(positions.last!.x, largestY)
        let allPoints = PointSequence(start: positions.first!, end: furthestPoint).map { $0 }
        let xs = Array(Set(allPoints.map { $0.x })).sorted()
        let ys = Array(Set(allPoints.map { $0.y })).sorted()
        var output = ""

        for y in ys {
            for x in xs {
                if positions.contains(Point(x, y)) {
                    output.append("X")
                } else {
                    output.append(" ")
                }
            }
            output.append("\n")
        }

        return output + "\nTime: \(time)"
    }
}

struct Star {
    let position: Point
    let velocity: Vector2D
}

extension Star {
    init(_ string: String) {
        let pointString = string.drop { $0 != "<" }
            .dropFirst()
            .prefix { $0 != ">" }
            .filter { $0 != " " }
        position = Point(pointString)
        let velocityString = string.reversed()
            .dropFirst()
            .prefix { $0 != "<" }
            .reversed()
            .filter { $0 != " " }
        velocity = Vector2D(String(velocityString))
    }
}

struct Vector2D {
    let dx: Int
    let dy: Int

    init(_ string: String) {
        let components = string.trimmingCharacters(in: .whitespaces).split(separator: ",")
        dx = Int(components[0])!
        dy = Int(components[1].trimmingCharacters(in: .whitespaces))!
    }
}

func + (lhs: Point, rhs: Vector2D) -> Point {
    Point(lhs.x + rhs.dx, lhs.y + rhs.dy)
}
