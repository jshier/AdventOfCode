//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayNine(_ output: inout DayOutput) async {
        let input = String.input(forDay: .nine, year: .twentyOne)
//        let input = """
//        2199943210
//        3987894921
//        9856789892
//        8767896789
//        9899965678
//        """

        let caveMap = Grid(input.byLines().map { $0.asInts() })
        let lowerPoints: [Point] = caveMap.points.reduce(into: []) { partialResult, point in
            let adjacentValues = caveMap.adjacentValues(for: point)
            if adjacentValues.min()! > caveMap[point] {
                partialResult.append(point)
            }
        }
        let riskLevels = lowerPoints.map { caveMap[$0] + 1 }

        output.stepOne = "\(riskLevels.sum)"
        output.expectedStepOne = "585"

        let counts: [Int] = await lowerPoints.concurrentMap { point in
            var pointsToCheck = [point]
            var seen: Set<Point> = []

            while let point = pointsToCheck.popLast() {
                guard seen.insert(point).inserted else { continue }

                pointsToCheck.append(contentsOf: caveMap.adjacentPointValues(for: point)
                    .filter { $0.value != 9 }
                    .map(\.point))
            }

            return seen.count
        }

        output.stepTwo = "\(counts.max(count: 3).product())"
    }
}
