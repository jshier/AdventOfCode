//
//  Day618.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/6/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day618: Day {
    override func perform() {
//        let input = String.input(forDay: 6)
        let input = """
                    1,1
                    1,6
                    8,3
                    3,4
                    5,5
                    8,9
                    """
        let points = input.byLines().map(Point.init)
        let sorted = points.sorted()
        var closestPointMap: [Point: Point] = [:]
        let largestY = sorted.map { $0.y }.max()!
        let furthestPoint = Point(sorted.last!.x, largestY)
        outer: for point in PointSequence(start: sorted.first!, end: furthestPoint) {
            var shortestDistance = Int.max
            for actualPoint in sorted {
                guard shortestDistance != 0 else { continue outer }
                
                let distance = actualPoint.manhattanDistance(to: point)
                if distance < shortestDistance {
                    closestPointMap[point] = actualPoint
                    shortestDistance = distance
                }
            }
        }
        let areas = NSCountedSet(array: Array(closestPointMap.values))
        stageOneOutput = "\(areas.maxItemCount())"
    }
}
