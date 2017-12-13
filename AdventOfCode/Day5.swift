//
//  Day5.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

class Day5: Day {
    override func perform() {
        let input = String.input(forDay: 5)
        let instructions = input.split(separator: "\n").map(String.init).flatMap(Int.init)
        
        stageOneOutput = "\(performStageOneProgram(with: instructions))"
        stageTwoOutput = "\(performStageTwoProgram(with: instructions))"
    }
    
    func performStageOneProgram(with program: [Int]) -> Int {
        var instructions = program
        var index = instructions.startIndex
        var steps = 0
        while index < instructions.endIndex {
            let jump = instructions[index]
            instructions[index] += 1
            index = index + jump
            steps += 1
        }
        
        return steps
    }
    
    func performStageTwoProgram(with program: [Int]) -> Int {
        var instructions = program
        var index = instructions.startIndex
        var steps = 0
        while index < instructions.endIndex {
            let jump = instructions[index]
            instructions[index] += (jump >= 3) ? -1 : 1
            index = index + jump
            steps += 1
        }
        
        return steps
    }
}
