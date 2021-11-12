//
//  Day21.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/26/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day21: Day {
    override func perform() {
        let fileInput = String.input(forDay: 21, year: 2017)
//        let testInput = """
//                        ../.# => ##./#../...
//                        .#./..#/### => #..#/..../..../#..#
//                        """
        let input = fileInput
//        let testIterations = 2
        let fileIterations = 5
        let iterations = fileIterations
        let art = FractalArt(lines: input.split(separator: "\n").map(String.init))
        art.enhance(iterations: iterations)

        stageOneOutput = "\(art.pixelsOn)"

        let stageTwoArt = FractalArt(lines: input.split(separator: "\n").map(String.init))
        stageTwoArt.enhance(iterations: 18)

        stageTwoOutput = "\(stageTwoArt.pixelsOn)"
    }

    final class FractalArt {
        private var image: [String]
        private let rules: [String: String]
        private var size: Int { image.count }
        var pixelsOn: Int {
            image.map { $0.count { $0 == "#" } }.reduce(0, +)
        }

        init(lines: [String]) {
            var buildingRules: [String: String] = [:]
            let separatedRules = lines.map { $0.components(separatedBy: " => ") }
            for separatedRule in separatedRules {
                let permutations = separatedRule[0].rulePermutations()
                let transform = separatedRule[1]
                permutations.forEach { buildingRules[$0] = transform }
            }
            rules = buildingRules
            image = ".#./..#/###".asArray()
        }

        func enhance(iterations: Int = 5) {
            for _ in 0..<iterations {
                if size % 2 == 0 {
                    let splits = image.splitInto2x2()
                    let strings = splits.map { $0.asRuleString() }
                    let transformed = strings.map { rules[$0]! }
                    let splitTransforms = transformed.map { $0.asArray() }
                    let half = size / 2
                    var rebuilt: [String] = []
                    for i in stride(from: 0, to: splitTransforms.count - 1, by: half) {
                        for y in 0..<splitTransforms[i].count {
                            var result: [String] = []
                            for x in (0 + i)..<(half + i) {
                                result.append(splitTransforms[x][y])
                            }
                            rebuilt.append(result.joined())
                        }
                    }
                    image = rebuilt
                } else {
                    assert(size % 3 == 0)
                    guard size > 3 else { image = rules[image.asRuleString()]!.asArray(); continue }

                    let splits = image.splitInto3x3()
                    let strings = splits.map { $0.asRuleString() }
                    let transformed = strings.map { rules[$0]! }
                    let splitTransforms = transformed.map { $0.asArray() }
                    let third = size / 3
                    var rebuilt: [String] = []
                    for i in stride(from: 0, to: splitTransforms.count - 1, by: third) {
                        for y in 0..<splitTransforms[i].count {
                            var result: [String] = []
                            for x in (0 + i)..<(third + i) {
                                result.append(splitTransforms[x][y])
                            }
                            rebuilt.append(result.joined())
                        }
                    }
                    image = rebuilt
                }
            }
        }
    }
}

private extension String {
    func asArray() -> [String] {
        split(separator: "/").map(String.init)
    }
}

private extension Array where Element == String {
    func asRuleString() -> String {
        joined(separator: "/")
    }

    func splitInto2x2() -> [[String]] {
        assert(count % 2 == 0)

        var intermediate: [[String]] = []

        var yIndex = startIndex
        while yIndex < endIndex {
            let firstY = yIndex
            let secondY = index(after: firstY)
            var firstXIndex = self[firstY].startIndex
            var secondXIndex = self[secondY].startIndex
            while firstXIndex < self[firstY].endIndex && secondXIndex < self[secondY].endIndex {
                let nextFirst = self[firstY].index(after: firstXIndex)
                let nextSecond = self[secondY].index(after: secondXIndex)
                let firstLine = String(self[firstY][firstXIndex...nextFirst])
                let secondLine = String(self[secondY][secondXIndex...nextSecond])
                intermediate.append([firstLine, secondLine])
                firstXIndex = self[firstY].index(after: nextFirst)
                secondXIndex = self[secondY].index(after: nextSecond)
            }
            yIndex = index(after: secondY)
        }

        return intermediate
    }

    func splitInto3x3() -> [[String]] {
        assert(count % 3 == 0)

        var intermediate: [[String]] = []

        var yIndex = startIndex
        while yIndex < endIndex {
            let firstY = yIndex
            let secondY = index(after: firstY)
            let thirdY = index(after: secondY)
            var firstXIndex = self[firstY].startIndex
            var secondXIndex = self[secondY].startIndex
            var thirdXIndex = self[thirdY].startIndex
            while firstXIndex < self[firstY].endIndex && secondXIndex < self[secondY].endIndex, thirdXIndex < self[thirdY].endIndex {
                let nextFirst = self[firstY].index(2, after: firstXIndex)
                let nextSecond = self[secondY].index(2, after: secondXIndex)
                let nextThird = self[thirdY].index(2, after: thirdXIndex)
                let firstLine = String(self[firstY][firstXIndex...nextFirst])
                let secondLine = String(self[secondY][secondXIndex...nextSecond])
                let thirdLine = String(self[thirdY][thirdXIndex...nextThird])
                intermediate.append([firstLine, secondLine, thirdLine])
                firstXIndex = self[firstY].index(after: nextFirst)
                secondXIndex = self[secondY].index(after: nextSecond)
                thirdXIndex = self[thirdY].index(after: nextThird)
            }
            yIndex = index(after: thirdY)
        }

        return intermediate
    }

//    func splitIntoSquares(size: Int) -> [[String]] {
//        assert(count % size == 0)
//
//        var result: [[String]] = []
//
//        var yIndex = startIndex
//        while yIndex < endIndex {
//            let yIndicies = [yIndex] + next(count - 1, indexesAfter: yIndex)
//            let ys = self[yIndex..<index(count, after: yIndex)]
//
//
//
//            yIndex = index(count, after: yIndex)
//        }
//
//        return result
//    }
}

extension Collection {
    func next(_ count: Int, indexesAfter index: Index) -> [Index] {
        var indexes: [Index] = []
        var lastIndex = index
        for _ in 0..<count {
            lastIndex = self.index(after: lastIndex)

            guard lastIndex != endIndex else { break }

            indexes.append(lastIndex)
        }

        return indexes
    }

    func index(_ count: Int, after index: Index) -> Index {
        guard let lastIndex = next(count, indexesAfter: index).last else { return index }

        return lastIndex
    }
}

extension String {
    func rulePermutations() -> Set<String> {
        let lines = asArray()
        let flippedVertical = lines.flipVertical()
        let flippedHorizontal = lines.flipHorizontal()
        let rotatedRight = lines.rotateRight()
        let rotatedLeft = lines.rotateLeft()
        let rightFlip = rotatedRight.flipVertical()
        let leftFlip = rotatedLeft.flipVertical()
        let permutations = [asArray(), flippedVertical, flippedHorizontal, rotatedRight, rotatedLeft, rightFlip, leftFlip]
        return Set(permutations.map { $0.joined(separator: "/") })
    }
}

extension Array where Element == String {
    func flipVertical() -> [String] {
        reversed()
    }

    func flipHorizontal() -> [String] {
        map { String($0.reversed()) }
    }

    func rotateRight() -> [String] {
        var rotatedRight: [String] = []

        var index = self[0].startIndex
        while index < self[0].endIndex {
            var rotatedRow = ""
            for line in self {
                rotatedRow.append(line[index])
            }
            rotatedRight.append(rotatedRow)
            index = self[0].index(after: index)
        }

        return rotatedRight
    }

    func rotateLeft() -> [String] {
        rotateRight().map { String($0.reversed()) }
    }
}
