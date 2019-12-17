//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1619: Day {
    override var expectedStageOneOutput: String? { "70856418" }
    override var expectedStageTwoOutput: String? { "87766336" }

    override func perform() {
        let input = String.input(forDay: 16, year: 2019)
//        let input = "12345678"
//        let input = "03036732577212944063491565474664"
        let digits = input.trimmingWhitespace().chunked(into: 1).map(String.init).compactMap(Int.init)
        let pattern = [0, 1, 0, -1]

        func calculateTransform(for digits: [Int]) -> [Int] {
            var transformDigits = digits
            var newDigits: [Int] = []
            newDigits.reserveCapacity(digits.count)
            for _ in 0..<100 {
                newDigits.removeAll(keepingCapacity: true)
                for index in 0..<transformDigits.count {
                    let onesIndices = stride(from: index, to: transformDigits.count, by: 4 * (index + 1))
                    let onesSubSums = onesIndices.map {
                        transformDigits[$0..<min($0 + (index + 1), transformDigits.endIndex)].reduce(0, +)
                    }
                    let ones = onesSubSums.reduce(0, +)

                    let negativeStart = (3 * (index + 1))
                    let negativeIndices = stride(from: negativeStart - 1, to: transformDigits.count, by: 4 * (index + 1))
                    let negativeSubSums = negativeIndices.map {
                        transformDigits[$0..<min($0 + (index + 1), transformDigits.endIndex)].reduce(0, +)
                    }
                    let negatives = negativeSubSums.reduce(0, +)

                    newDigits.append(abs(ones - negatives) % 10)
                }
                transformDigits = newDigits
            }
            return transformDigits
        }

        stageOneOutput = String(calculateTransform(for: digits).map(String.init).joined().prefix(8))

        let offset = digits.prefix(7).reversed().enumerated().reduce(0) { $0 + (Int(pow(10, Double($1.offset))) * $1.element) }
        let needed = (digits.count * 10_000) - offset
        var lastDigits: [Int] = []
        lastDigits.reserveCapacity(needed)
        var reversed = Array(digits.reversed())
        for _ in 0..<100 {
            var previousSum = 0
            lastDigits.removeAll(keepingCapacity: true)
            for index in 0..<needed {
                let circularIndex = index % reversed.count
                let newSum = reversed[circularIndex] + previousSum
                lastDigits.append(newSum % 10)
                previousSum = newSum
            }
            reversed = lastDigits
        }

        stageTwoOutput = reversed.reversed().prefix(8).map(String.init).joined()
    }
}

extension Sequence {
    func duplicateByElement(count: Int) -> [Element] {
        flatMap { repeatElement($0, count: count) }
    }
}

extension Collection where Index == Int {
    func cycle(toLength length: Int) -> [Element] {
        if count >= length { return Array(prefix(length)) }

        return zip(0..<length, cycle()).map { $1 }
    }
}
