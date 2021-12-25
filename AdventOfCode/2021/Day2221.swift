//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import CryptoKit

extension TwentyTwentyOne {
    func dayTwentyTwo(input: String, output: inout DayOutput) async {
        let steps = input.byLines().map(Step.init)
        let applicableSteps = steps.filter(\.isInProcedureArea)

        var cube: [Point3D: Bool] = [:]

        for step in applicableSteps {
            for coords in product(product(step.region.xRange, step.region.yRange), step.region.zRange) {
                let point = Point3D(x: coords.0.0, y: coords.0.1, z: coords.1)
                cube[point] = (step.action == .on) ? true : false
            }
        }

        output.stepOne = "\(cube.values.count { $0 == true })"
    }
}

private struct Step {
    enum Action: String {
        case on, off
    }

    struct Region {
        let xRange, yRange, zRange: ClosedRange<Int>
    }

    let action: Action
    let region: Region

    var isInProcedureArea: Bool {
        region.xRange.isIn(-50...50) && region.yRange.isIn(-50...50) && region.zRange.isIn(-50...50)
    }

    init(_ string: String) {
        let parts = string.components(separatedBy: " ")
        let ranges = parts[1].components(separatedBy: ",")
            .map { String($0.dropFirst(2)).components(separatedBy: "..").compactMap(Int.init) }
            .map { min($0[0], $0[1])...max($0[0], $0[1]) }

        action = Action(rawValue: parts[0])!
        region = Region(xRange: ranges[0], yRange: ranges[1], zRange: ranges[2])
    }
}

private extension ClosedRange where Element == Int {
    func isIn(_ range: ClosedRange<Element>) -> Bool {
        first! >= range.first! && last! <= range.last!
    }
}
