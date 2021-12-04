//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

extension TwentyTwentyOne {
    func dayThree(_ output: inout DayOutput) async {
//        let input = String.input(forDay: .three, year: .twentyOne)
        let input = """
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
        """
        let lines = input.byLines()
        let numbers = lines.compactMap { Int($0, radix: 2) }
        let length = lines[0].count
        let halfCount = Int(numbers.count / 2)

        let transposed = lines.transposed()
        let averages = transposed.map { Double($0.compactMap { Int(String($0)) }.sum) / Double($0.count) }
        let dominantBits = averages.map { $0 >= 0.5 ? 1 : 0 }
        print(dominantBits)

        let onesCounts = numbers.onesCounts(upToLength: length)

        let gamma = onesCounts.reversed().indexed().reduce(0) { result, indexCount in
            (indexCount.element > halfCount) ? result + (1 << indexCount.index) : result
        }
        let epsilon = onesCounts.reversed().indexed().reduce(0) { result, indexCount in
            (indexCount.element < halfCount) ? result + (1 << indexCount.index) : result
        }

        output.stepOne = "\(gamma * epsilon)"
        output.expectedStepOne = "3923414"

        output.stepTwo = "\(numbers.filteredMostCommonBinaryValue(upToLength: length) * numbers.filteredLeastCommonBinaryValue(upToLength: length))"
        output.expectedStepTwo = "5852595"
    }
}

private extension Array where Element == Int {
    func onesCounts(upToLength length: Int) -> [Int] {
        var counts = Array(repeating: 0, count: length)
        for element in self {
            for position in 0..<length {
                let bit = 1 << position
                let isOneAtPosition = ((element & bit) == bit)
                if isOneAtPosition {
                    counts[position] += 1
                }
            }
        }

        return counts.reversed()
    }

    func mostCommonBits(upToLength length: Int) -> [Int] {
        onesCounts(upToLength: length).map { $0 >= (count - $0) ? 1 : 0 }
    }

    func leastCommonBits(upToLength length: Int) -> [Int] {
        onesCounts(upToLength: length).map { $0 >= (count - $0) ? 0 : 1 }
    }

    func binaryColumn(ofSize size: Int) -> String {
        map { $0.binaryRepresentation(paddedToLength: size) }.joined(separator: "\n")
    }

    func filteredMostCommonBinaryValue(upToLength length: Int) -> Int {
        filteredCommonBinaryValue(upToLength: length) { values, length in
            values.mostCommonBits(upToLength: length)
        }
    }

    func filteredLeastCommonBinaryValue(upToLength length: Int) -> Int {
        filteredCommonBinaryValue(upToLength: length) { values, length in
            values.leastCommonBits(upToLength: length)
        }
    }

    func filteredCommonBinaryValue(upToLength length: Int,
                                   usingProvider bitProvider: (_ values: [Int], _ length: Int) -> [Int]) -> Int {
        var commonBits = bitProvider(self, length)
        var possibleValues = self
        var position = 0
        while possibleValues.count > 1 {
            let bit = commonBits[position]
            let value = 1 << (length - position - 1)
            possibleValues = possibleValues.filter { number in
                if bit == 1 {
                    return (value & number) != 0
                } else {
                    return (value & ~number) != 0
                }
            }
            commonBits = bitProvider(possibleValues, length)
            position += 1
        }

        return possibleValues[0]
    }
}

extension Collection {
    func transposed() -> [[Element.Element]] where Element: Collection {
        guard !isEmpty else { return [[]] }
        guard allSatisfy({ $0.count == first?.count }) else { fatalError("transpose() only works on collections of collections with the same number of elements.") }

        var output: [[Element.Element]] = Array(repeating: [], count: first!.count)
        for element in self {
            var index = 0
            for innerElement in element {
                output[index].append(innerElement)
                index += 1
            }
        }

        return output
    }
}
