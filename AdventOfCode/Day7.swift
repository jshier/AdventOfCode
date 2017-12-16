//
//  Day7.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/15/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day7: Day {
    override func perform() {
        let input =
            """
            pbga (66)
            xhth (57)
            ebii (61)
            havc (66)
            ktlj (57)
            fwft (72) -> ktlj, cntj, xhth
            qoyq (66)
            padx (45) -> pbga, havc, qoyq
            tknk (41) -> ugml, padx, fwft
            jptl (61)
            ugml (68) -> gyxo, ebii, jptl
            gyxo (61)
            cntj (57)
            """
            //String.input(forDay: 7)
        let lines = input.split(separator: "\n")
        let programs = lines.map(Program.init)
        let allNames = Set(programs.map { $0.name })
        let allHostedNames = Set(programs.flatMap { $0.heldNames })
        let baseName = allNames.subtracting(allHostedNames)
        let baseProgramName = baseName.first!
        stageOneOutput = baseProgramName
        
//        let baseProgram = programs.first { $0.name == baseProgramName }!
//        let programMap = Dictionary(uniqueKeysWithValues: zip(programs.map { $0.name }, programs))
//        let weights = Dictionary(uniqueKeysWithValues: zip(programs.map { $0.name }, programs.map { $0.weight }))
    }
    
    struct Program {
        let name: String
        let weight: Int
        let heldNames: [String]
        
        init(line: Substring) {
            let endNameIndex = line.index { $0 == " " }!
            name = String(line.prefix(upTo: endNameIndex))
            let startingParens = line.index { $0 == "(" }!
            let endingParens = line.index { $0 == ")" }!
            weight = Int(line[line.index(after: startingParens)..<endingParens])!
            let separatedLine = line.components(separatedBy: "-> ")
            if separatedLine.count == 2 {
                heldNames = separatedLine[1].components(separatedBy: ", ")
            } else {
                heldNames = []
            }
        }
    }
}
