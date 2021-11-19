//
//  Day7.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/15/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day7: Day {
    override func perform() async {
//        let input =
//            """
//            pbga (66)
//            xhth (57)
//            ebii (61)
//            havc (66)
//            ktlj (57)
//            fwft (72) -> ktlj, cntj, xhth
//            qoyq (66)
//            padx (45) -> pbga, havc, qoyq
//            tknk (41) -> ugml, padx, fwft
//            jptl (61)
//            ugml (68) -> gyxo, ebii, jptl
//            gyxo (61)
//            cntj (57)
//            """
        let input = String.input(forDay: 7, year: 2017)
        let lines = input.split(separator: "\n").map(String.init)
        let allNames: [String] = lines.map { line in
            let endNameIndex = line.firstIndex { $0 == " " }!
            return String(line.prefix(upTo: endNameIndex))
        }
        let allWeights: [Int] = lines.map { line in
            let startingParens = line.firstIndex { $0 == "(" }!
            let endingParens = line.firstIndex { $0 == ")" }!
            return Int(line[line.index(after: startingParens)..<endingParens])!
        }
        let allLinks: [[String]] = lines.map { line in
            let separatedLine = line.components(separatedBy: "-> ")
            if separatedLine.count == 2 {
                return separatedLine[1].components(separatedBy: ", ")
            } else {
                return []
            }
        }
        let namesAndWeights = Dictionary(zip(allNames, allWeights)) { _, rhs in rhs }
        let namesAndLinks = Dictionary(zip(allNames, allLinks)) { _, rhs in rhs }

        let uniqueNames = Set(allNames)
        let uniqueHostedNames = Set(allLinks.flatMap { $0 })
        let baseName = uniqueNames.subtracting(uniqueHostedNames)
        let baseProgramName = baseName.first!

        stageOneOutput = baseProgramName

        func createProgram(_ name: String) -> Program {
            Program(name: name, weight: namesAndWeights[name]!, heldPrograms: namesAndLinks[name]?.map(createProgram) ?? [])
        }

        let baseProgram = createProgram(baseProgramName)

        stageTwoOutput = "\(baseProgram.heldWeightMismatch)"
        baseProgram.findWeightMismatch()

//        let baseProgram = programs.first { $0.name == baseProgramName }!
//        let programMap = Dictionary(uniqueKeysWithValues: zip(programs.map { $0.name }, programs))
//        let weights = Dictionary(uniqueKeysWithValues: zip(programs.map { $0.name }, programs.map { $0.weight }))
    }

    struct Program {
        let name: String
        let weight: Int
        let heldPrograms: [Program]

        var heldNames: [String] {
            heldPrograms.map { $0.name }
        }

        var heldWeight: Int {
            heldPrograms.map { $0.totalWeight }.reduce(0, +)
        }

        var totalWeight: Int {
            heldWeight + weight
        }

        var heldWeights: [Int] {
            heldPrograms.map { $0.heldWeight }
        }

        var heldTotalWeights: [Int] {
            heldPrograms.map { $0.totalWeight }
        }

        var heldWeightMismatch: Bool {
            !heldTotalWeights.allElementsEqual()
        }

        func findWeightMismatch() {
            if !heldTotalWeights.allElementsEqual() {
                print(heldPrograms.map { $0.heldTotalWeights })
                print(heldTotalWeights)
                print(heldPrograms.map { $0.weight })
                print(heldNames)
                heldPrograms.forEach { $0.findWeightMismatch() }
            }
        }
    }
}

struct SimpleCountedSet<Element: Hashable> {
    let counts: [Element: Int]

    init(_ array: [Element]) {
        var counts: [Element: Int] = [:]
        for element in array {
            guard let count = counts[element] else { counts[element] = 1; break }

            counts[element] = count + 1
        }

        self.counts = counts
    }

    func element(for queriedCount: Int) -> Element {
        for (element, count) in counts {
            if queriedCount == count {
                return element
            }
        }

        fatalError("No element with count: \(queriedCount)")
    }
}
