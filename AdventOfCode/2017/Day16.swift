//
//  Day16.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/16/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day16: Day {
    override func perform() {
        let fileInput = String.input(forDay: 16)
        //let filePrograms = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]
        let filePrograms = "abcdefghijklmnop"
//        let sampleInput = "s1,x3/4,pe/b"
//        let samplePrograms = ["a", "b", "c", "d", "e"]
        
        let input = fileInput
        var programs = filePrograms
        let moves = input.split(separator: ",").map(Move.init)
        var cache: [String: String] = [:]
        for move in moves {
            move.perform(on: &programs)
        }
        stageOneOutput = programs
        cache[filePrograms] = programs
        
        for i in 1..<1_000_000_000 {
            if i % 1_000_000 == 0 { print(i) }
            if let result = cache[programs] {
                programs = result
            } else {
                let initial = programs
                for move in moves {
                    move.perform(on: &programs)
                }
                cache[initial] = programs
            }
        }
        stageTwoOutput = programs
    }
    
    enum Move {
        case spin(size: Int)
        case swapIndex(first: Int, second: Int)
        case swapProgram(first: String, second: String)
        
        init(rawMove: Substring) {
            let move = rawMove.dropFirst()
            switch rawMove.prefix(1) {
            case "s":
                self = .spin(size: Int(move)!)
            case "x":
                let indices = move.split(separator: "/")
                self = .swapIndex(first: Int(indices[0])!, second: Int(indices[1])!)
            case "p":
                let programs = move.split(separator: "/")
                self = .swapProgram(first: String(programs[0]), second: String(programs[1]))
            default:
                fatalError()
            }
        }
        
//        func perform(on programs: inout [String]) {
//            switch self {
//            case .spin(let size):
//                let end = programs.suffix(size)
//                programs.removeLast(size)
//                programs.insert(contentsOf: end, at: 0)
//            case .swapIndex(let first, let second):
//                programs.swapAt(first, second)
//            case .swapProgram(let first, let second):
//                let firstIndex = programs.index { $0 == first }!
//                let secondIndex = programs.index { $0 == second }!
//                programs.swapAt(firstIndex, secondIndex)
//            }
//        }
        
        func perform(on string: inout String) {
            switch self {
            case .spin(let size):
                string = String(string.dropFirst(string.count - size) + string.prefix(string.count - size))
            case .swapIndex(let first, let second):
                string.swapAt(first, second)
            case .swapProgram(let first, let second):
                let firstIndex = string.index(of: first.first!)!
                let secondIndex = string.index(of: second.first!)!
                string.swapAt(firstIndex, secondIndex)
            }
        }
    }
}

