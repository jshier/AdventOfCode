//
//  Day.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

class Day {
    var stageOneOutput: String?
    var stageTwoOutput: String?
    
    func perform() {
        print("Must override perform in subclasses.")
    }
    
    func output() -> String {
        perform()
        let header = "========== \(type(of: self)) ==========\n"
        let stageOne: String
        if let stageOneOutput = stageOneOutput {
            stageOne = "Stage 1: \(stageOneOutput)\n"
        } else {
            stageOne = ""
        }
        
        let stageTwo: String
        if let stageTwoOutput = stageTwoOutput {
            stageTwo = "Stage 2: \(stageTwoOutput)\n"
        } else {
            stageTwo = ""
        }
        
        return header + stageOne + stageTwo
    }
}
