//
//  Day318.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/2/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day318: Day {
    override func perform() {
        let input = String.input(forDay: 3, year: 2018)
//        let input = """
//        #1 @ 1,3: 4x4
//        #2 @ 3,1: 4x4
//        #3 @ 5,5: 2x2
//        #4 @ 0,0: 1x1
//        """
        let claims: [Claim] = input.byLines().map { line in
            let first = line.components(separatedBy: " @ ")
            let seconds = first[1].components(separatedBy: ": ")
            let id = first[0]
            let origin = Point(seconds[0])
            let size = Size(seconds[1])

            return Claim(id: id, origin: origin, size: size)
        }
        var claimedPoints: [Point: Set<Claim>] = [:]
        for claim in claims {
            for point in claim.areaPoints {
                var currentClaims = claimedPoints[point, default: []]
                currentClaims.insert(claim)
                claimedPoints[point] = currentClaims
            }
        }
        let twoOrMore = claimedPoints.values.count { $0.count > 1 }
//        print(claimedPoints.map { "\($0.0): \($0.1.map { $0.id })" })
        stageOneOutput = "\(twoOrMore)"
        var id: String?
        loop: for claim in claims {
            var onlyOne = 0
            for point in claim.areaPoints {
                if claimedPoints[point]!.count == 1 { onlyOne += 1 }
            }
            if onlyOne == claim.areaPoints.count { id = claim.id; break loop }
        }
        stageTwoOutput = id
    }

    struct Claim: Hashable {
        let id: String
        let origin: Point
        let size: Size

        var areaPoints: [Point] {
            let points = origin * size
            precondition(points.count == size.area)
            return points
        }
    }
}

struct Size: Hashable {
    let height: Int
    let width: Int

    var area: Int { height * width }

    init(_ string: String) {
        let split = string.split(separator: "x")
        width = Int(split[0])!
        height = Int(split[1])!
    }
}

extension Size: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Size: CustomStringConvertible {
    var description: String {
        "\(width)x\(height)"
    }
}

func * (lhs: Point, rhs: Size) -> [Point] {
    let farthestPoint = Point(lhs.x + rhs.width - 1, lhs.y + rhs.height - 1)
    return PointSequence(start: Point(lhs.x, lhs.y), end: farthestPoint).map { $0 }
}
