//
//  Day19.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/26/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day19: Day {
    override func perform() {
        let fileInput = String.input(forDay: 19)
//        let testInput = """
//                             |         
//                             |  +--+   
//                             A  |  C   
//                         F---|----E|--+
//                             |  |  |  D
//                             +B-+  +--+
//                        """
        let input = fileInput
        let lines = input.split(separator: "\n")
        let pathMap = PathMap(lines)
        let tokensAndSteps = pathMap.tokensAndStepsFollowingPath()
        
        stageOneOutput = tokensAndSteps.tokens
        stageTwoOutput = "\(tokensAndSteps.steps)"
    }
}

final class PathMap {
    private var map: [Point: Character] = [:]
    let startingPoint: Point    
    
    init(_ lines: [Substring]) {
        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                guard character != " " else { continue }
                
                map[Point(x, -y)] = character
            }
        }
        
        startingPoint = Point(lines[0].index(of: "|")!.encodedOffset, 0)
    }
    
    func tokensAndStepsFollowingPath() -> (tokens: String, steps: Int) {
        var direction = Direction.down
        var currentPoint = startingPoint
        var tokens = ""
        var steps = 0
        while let currentCharacter = map[currentPoint] {
            switch currentCharacter {
            case "-", "|": currentPoint += direction.forwardOffset
            case "+": 
                let left = direction.turn(.left)
                let leftPoint = currentPoint + left.forwardOffset
                let right = direction.turn(.right)
                let rightPoint = currentPoint + right.forwardOffset
                if map[leftPoint] != nil {
                    currentPoint = leftPoint
                    direction = left
                } else if map[rightPoint] != nil {
                    currentPoint = rightPoint
                    direction = right
                } else {
                    fatalError("Impossible!")
                }
            default: 
                tokens.append(currentCharacter)
                currentPoint += direction.forwardOffset
            }
            
            steps += 1
        }
        return (tokens, steps)
    }
}
