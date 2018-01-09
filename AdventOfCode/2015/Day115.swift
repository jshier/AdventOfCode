//
//  Day115.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

class Day115: Day {
    override func perform() {
        let input = String.input(forDay: 1, year: 2015)
        let opens = input.count { $0 == "(" }
        let closeds = input.count { $0 == ")" }
        
        stageOneOutput = "\(opens - closeds)"
        
        var value = 0
        var position = 0
        
        while value != -1 {
            if input[position] == "(" {
                value += 1
            } else {
                value -= 1
            }
            
            position += 1
        }
        
        stageTwoOutput = "\(position)"
    }
}

extension String {
    /// Extremely inefficient!
    subscript(index: Int) -> Character {
        return self[self.index(startIndex, offsetBy: index)]
    }
}
