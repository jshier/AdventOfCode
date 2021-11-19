//
//  Day215.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

extension TwentyFifteen {
    func dayTwo(_ output: inout YearRunner.DayOutput) async {
        let input = String.input(forDay: 2, year: 2015)
        let presents = input.split(separator: "\n").map(Present.init)
        let totalArea = presents.map(\.presentArea).reduce(0, +)

        output.stepOne = "\(totalArea)"
        output.expectedStepOne = "1588178"

        let totalRibbon = presents.map(\.ribbonLength).reduce(0, +)

        output.stepTwo = "\(totalRibbon)"
        output.expectedStepTwo = "3783758"
    }
}

private struct Present {
    let length: Int
    let width: Int
    let height: Int

    init(_ substring: Substring) {
        let lwh = substring.split(separator: "x").compactMap { Int($0) }
        length = lwh[0]
        width = lwh[1]
        height = lwh[2]
    }

    var sides: [Int] {
        let lw = length * width
        let lh = length * height
        let wh = width * height

        return [lw, lw, lh, lh, wh, wh]
    }

    var totalArea: Int {
        sides.reduce(0, +)
    }

    var presentArea: Int {
        totalArea + sides.min()!
    }

    var volume: Int {
        length * width * height
    }

    var perimeters: [Int] {
        let lw = length + width
        let lh = length + height
        let wh = width + height

        return [lw * 2, lh * 2, wh * 2]
    }

    var smallestPerimeter: Int {
        perimeters.min()!
    }

    var ribbonLength: Int {
        smallestPerimeter + volume
    }
}
