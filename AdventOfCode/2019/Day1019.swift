//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1019: Day {
    override var expectedStageOneOutput: String? { "329" }
    override var expectedStageTwoOutput: String? { "512" }

    override func perform() async {
        let input = String.input(forDay: 10, year: 2019)
//        let input = """
//        .#..#
//        .....
//        #####
//        ....#
//        ...##
//        """
//        let input = """
//        ......#.#.
//        #..#.#....
//        ..#######.
//        .#.#.###..
//        .#..#.....
//        ..#....#.#
//        #..#....#.
//        .##.#..###
//        ##...#..#.
//        .#....####
//        """
//        let input = """
//        #.........
//        ...A......
//        ...B..a...
//        .EDCG....a
//        ..F.c.b...
//        .....c....
//        ..efd.c.gb
//        .......c..
//        ....f...c.
//        ...e..d..c
//        """
//        let input = """
//        o.o...#.#.
//        .o#o....#.
//        .)....#...
//        o#.0.#.#.#
//        ....#.#.#.
//        .xo..##x.#
//        ..o...#x..
//        ..o#....##
//        ......#...
//        .xo##.###.
//        """
//        let input = """
//        .#....###24...#..
//        ##...##.13#67..9#
//        ##...#...5.8####.
//        ..#.....X...###..
//        ..#.#.....#....##
//        """

        let lines = input.byLines()

        let asteroids: Set<Point> = lines.enumerated().reduce(into: []) { output, offsetElement in
            let y = offsetElement.offset
            for (x, character) in offsetElement.element.enumerated() where character != "." {
                output.insert(Point(x, y))
            }
        }
        var visibles: [Point: Set<Offset>] = [:]
        for potential in asteroids {
            var offsets: Set<Offset> = []
            let rest = asteroids.subtracting([potential]).sorted {
                potential.distance(to: $0) < potential.distance(to: $1)
            }
            for other in rest {
                let offset = potential.offset(of: other)
                if !offsets.contains(where: { offset.isMultiple(of: $0) }) {
                    let divisor = abs(offset.dx.greatestCommonDivisor(with: offset.dy))
                    offsets.insert(Offset(offset.dx / divisor, offset.dy / divisor))
                }
            }
            visibles[potential] = offsets
        }

        let mostVisible = visibles.max { $0.value.count < $1.value.count }!

        stageOneOutput = "\(mostVisible.value.count)"

        let mostVisiblePoint = mostVisible.key
        var asteroidsToLaser = asteroids.subtracting([mostVisiblePoint]).sorted { mostVisiblePoint.distance(to: $0) < mostVisiblePoint.distance(to: $1) }
        var laseredAsteroids: [Point] = []
        let offsetsByAngle = mostVisible.value.sorted {
            let start = Offset(0, -1)
            let first = start.clockwiseAngle(to: $0)
            let second = start.clockwiseAngle(to: $1)

            return first < second
        }

        while !asteroidsToLaser.isEmpty {
            for offset in offsetsByAngle {
                if let index = asteroidsToLaser.firstIndex(where: { mostVisiblePoint.offset(of: $0).isMultiple(of: offset) }) {
                    laseredAsteroids.append(asteroidsToLaser[index])
                    asteroidsToLaser.remove(at: index)
                }
            }
        }

        let twoHundredth = laseredAsteroids[199]

        stageTwoOutput = "\(twoHundredth.x * 100 + twoHundredth.y)"
    }
}
