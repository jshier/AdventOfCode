//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayEight(_ output: inout DayOutput) async {
        let input = String.input(forDay: .eight, year: .twentyOne)

        let rightSide = input.byLines().flatMap { $0.components(separatedBy: " | ")[1].bySpaces() }
        let uniqueCounts = rightSide.reduce(0) { result, value in
            result + (([2, 3, 4, 7].contains(value.count)) ? 1 : 0)
        }
        output.stepOne = "\(uniqueCounts)"
        output.expectedStepOne = "512"

        let values = input.byLines().map { line -> Int in
            let sides = line.components(separatedBy: " | ")
            let analyzer = Inputs(sides[0].bySpaces().map(Set.init))
            return Int(sides[1].bySpaces().map { "\(analyzer.value(forSegments: $0))" }.joined())!
        }

        output.stepTwo = "\(values.sum)"
        output.expectedStepTwo = "1091165"
    }
}

private struct Inputs {
    private let mapping: [Set<Character>: Int]

    init(_ strings: [Set<Character>]) {
        let one = strings.first { $0.count == 2 }!
        let seven = strings.first { $0.count == 3 }!
        let four = strings.first { $0.count == 4 }!
        let eight = strings.first { $0.count == 7 }!

        let lengthSixes = strings.filter { $0.count == 6 }
        let six = lengthSixes.first { !$0.isSuperset(of: one) }!
        let lengthFives = strings.filter { $0.count == 5 }
        let three = lengthFives.first { $0.isSuperset(of: one) }!

        let leftSide = six.subtracting(three)
        let nine = lengthSixes.first { $0.subtracting(leftSide).count == 5 }!
        let lowerLeft = leftSide.subtracting(nine).first!
        let two = lengthFives.first { $0.contains(lowerLeft) }!
        let upperLeft = leftSide.subtracting(Set([lowerLeft])).first!
        let five = lengthFives.first { $0.contains(upperLeft) }!
        let zero = Set(lengthSixes).subtracting(Set([nine, six])).first!

        mapping = [zero: 0, one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9]
    }

    func value(forSegments segments: String) -> Int {
        mapping[Set(segments)]!
    }
}
