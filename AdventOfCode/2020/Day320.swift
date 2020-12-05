//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day320: Day {
    override var expectedStageOneOutput: String? { "228" }
    override var expectedStageTwoOutput: String? { "6818112000" }

    override func perform() {
        let input = String.input(forDay: 3, year: 2020)
//        let input = """
//        ..##.......
//        #...#...#..
//        .#....#..#.
//        ..#.#...#.#
//        .#...##..#.
//        ..#.##.....
//        .#.#.#....#
//        .#........#
//        #.##...#...
//        #...##....#
//        .#..#...#.#
//        """
        
        let characterGrid = input.byLines().map(Array.init)
        
        func countTreesForSlope(right: Int, down: Int) -> Int {
            var trees = 0
            var x = 0
            for row in characterGrid.dropFirst(down).striding(by: down) {
                let nextX = row.circularIndex(x, offsetBy: right)
                if row[nextX] == "#" {
                    trees += 1
                }
                x = nextX
            }
            
            return trees
        }
        
        stageOneOutput = "\(countTreesForSlope(right: 3, down: 1))"
        
        let treeCounts = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)].map(countTreesForSlope(right:down:))
        
        stageTwoOutput = "\(treeCounts.product())"
    }
}
