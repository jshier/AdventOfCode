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
        
        return """
        ========== \(type(of: self)) ==========
        Stage 1: \(stageOneOutput ?? "No output.")
        Stage 2: \(stageTwoOutput ?? "No output.")
        """
    }
}
