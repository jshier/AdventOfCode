//
//  Day11.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/26/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day11: Day {
    override func perform() {
        let fileInput = String.input(forDay: 11)
        //let testInput = "ne,ne,s,s"
        let input = fileInput
        let directions = input.split(separator: ",").map(String.init).flatMap(HexDirection.init)
        let points = directions.map { $0.point }
//        var result = Point(0, 0)
//        for point in points {
//            result = result + point
//        }
        let point = points.reduce(Point(0, 0), +)
        
        stageOneOutput = "\(point.squareDistance / 2)"
        
        let intermediatePoints = points.accumulate(Point(0, 0), +)
        let farthest = intermediatePoints.max()!
        
        stageTwoOutput = "\(farthest.squareDistance / 2)"
    }
}

enum HexDirection: String {
    case n, s, ne, se, nw, sw
    
    var opposite: HexDirection {
        switch self {
        case .n: return .s
        case .s: return .n
        case .ne: return .sw
        case .sw: return .ne
        case .nw: return .se
        case .se: return .nw
        }
    }
    
    var point: Point {
        switch self {
        case .n: return Point(0, 2)
        case .s: return Point(0, -2)
        case .ne: return Point(1, 1)
        case .nw: return Point(-1, 1)
        case .se: return Point(1, -1)
        case .sw: return Point(-1, -1)
        }
    }
}

extension HexDirection: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}

extension Array {
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}
