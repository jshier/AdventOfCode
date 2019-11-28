//
//  Day9.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/17/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day9: Day {
    override func perform() {
        let fileInput = String.input(forDay: 9, year: 2017)
//        let testInput = "{{{!!},{<>!!!e},{{!!}}}}"
        var input = fileInput
        input.filteringDestructive("!")

        func calculateScores() -> (score: Int, garbageScore: Int) {
            var nesting = 0
            var score = 0
            var garbageScore = 0
            var inGarbage = false
            for c in input {
                switch (c, inGarbage) {
                case ("<", false): inGarbage = true
                case (">", true): inGarbage = false
                case ("{", false):
                    nesting += 1
                case ("}", false):
                    score += nesting
                    nesting -= 1
                case (_, true):
                    garbageScore += 1
                default: continue
                }
            }
            return (score: score, garbageScore: garbageScore)
        }
        
        let scores = calculateScores()
        stageOneOutput = "\(scores.score)"
        stageTwoOutput = "\(scores.garbageScore)"
    }
    
    enum Block {
        case group, garbage
        
        var start: String {
            switch self {
            case .group: return "{"
            case .garbage: return "<"
            }
        }
        
        var end: String {
            switch self {
            case .group: return "}"
            case .garbage: return ">"
            }
        }
    }
    
    
}
