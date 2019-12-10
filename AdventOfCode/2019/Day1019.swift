//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1019: Day {
    override var expectedStageOneOutput: String? { nil }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() {
//        let input = String.input(forDay: 10, year: 2019)
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
        let input = """
        #.#...#.#.
        .###....#.
        .#....#...
        ##.#.#.#.#
        ....#.#.#.
        .##..###.#
        ..#...##..
        ..##....##
        ......#...
        .####.###.
        """
        let lines = input.byLines()
        let asteroids: [Point: Bool] = lines.enumerated().reduce(into: [:]) { (output, offsetElement) in
            let y = offsetElement.offset
            for (x, character) in offsetElement.element.enumerated() {
                output[Point(x, y)] = (character != ".")
            }
        }
        
        var allVisibles: [Point: [(point: Point, offset: (x: Int, y: Int))]] = [:]
        for point in asteroids.filter({ $0.value }).keys {
            var visibles: [(point: Point, offset: (x: Int, y: Int))] = []
            // 0 - x to count - x
            // 0 - y to count - y
            let xs = ((0 - point.x)..<(lines[0].count - point.x)).sorted { abs($0) < abs($1) }
            for xOffset in xs {
                let ys = ((0 - point.y)..<(lines.count - point.y)).sorted { abs($0) < abs($1) }
                for yOffset in ys {
                    let offset = (x: xOffset, y: yOffset)
                    
                    guard !((offset.x == 0) && (offset.y == 0)) else { continue }
                    
                    let position = point + offset
                    
//                    print("Point: \(point)")
//                    print("Offset: \(offset)")
//                    print("Position: \(position)")
                    
                    
                    if asteroids[position] == true  {
                        let isVisible = !visibles.map { $0.offset }.contains {
//                            let isMultiple: Bool
//                            switch ($0.x, $0.y) {
//                            case (0, 0): fatalError("Should've already filtered this out.")
//                            case (0, _): isMultiple = (offset.x == 0) && ((offset.y / $0.y) > 0)
//                            case (_, 0): isMultiple = (offset.y == 0) && ((offset.x / $0.x) > 0)
//                            default: isMultiple = (offset.y * $0.x) == (offset.x * $0.y)
//                            }
//                            if isMultiple { print("\(offset) is multiple of \($0)") }
                            return (offset.y * $0.x) == (offset.x * $0.y)
                        }
                        if isVisible {
                            visibles.append((point: position, offset: offset))
                        } else {
                            
                        }
                    }
                }
            }
            
            allVisibles[point] = visibles
        }
        
        let sorted = allVisibles.sorted { $0.value.count < $1.value.count }
        let mostVisible = sorted.last!
        print(mostVisible.key)
        stageOneOutput = "\(mostVisible.value.count)"
    }
}
