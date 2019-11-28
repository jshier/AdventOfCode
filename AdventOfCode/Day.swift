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
    
    var expectedStageOneOutput: String? { nil }
    var expectedStageTwoOutput: String? { nil }
    
    func perform() {
        print("Must override perform in subclasses.")
    }
    
    func output() -> String {
        perform()
        
        let stageOneCorrect = (stageOneOutput == (expectedStageOneOutput ?? "Fallback")) ? "Correct!" : "Incorrect!"
        let stageTwoCorrect = (stageTwoOutput == (expectedStageTwoOutput ?? "Fallback")) ? "Correct!" : "Incorrect!"
        
        return """
        ========== \(type(of: self)) ==========
        Stage 1: \(stageOneOutput ?? "No output.") \(stageOneCorrect)
        Stage 2: \(stageTwoOutput ?? "No output.") \(stageTwoCorrect)
        """
    }
}
