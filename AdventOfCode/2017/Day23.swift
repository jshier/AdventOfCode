//
//  Day23.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/22/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day23: Day {
    override func perform() {
        let fileInput = String.input(forDay: 23, year: 2017)
        let lines = fileInput.split(separator: "\n")
        let instructions = lines.map(Instruction.init)
        var program: [String: Int] = ["a": 0, "b": 0, "c": 0, "d": 0, "e": 0, "f": 0, "g": 0, "h": 0]
        var instructionPointer = 0
        var multiplies = 0
        
        while instructionPointer < lines.count {
            instructions[instructionPointer].perform(on: &program, instructionPointer: &instructionPointer, multiplies: &multiplies)
        }
        
        stageOneOutput = "\(multiplies)"
        
        var count = 0
        for i in stride(from: 106500, to: 123500 + 1, by: 17) {
            for j in 2..<i {
                if i % j == 0 {
                    count += 1
                    break
                }
            }
        }
        
        stageTwoOutput = "\(count)"
    }
    
    struct Instruction {
        let action: Action
        let left: Source
        let right: Source?
        let original: String
        
        init(line: Substring) {
            let parts = line.split(separator: " ")
            action = Action(rawValue: String(parts[0]))!
            left = Source(parts[1])
            right = (parts.count == 3) ? Source(parts[2]) : nil
            original = String(line)
        }
        
        func perform(on program: inout [String: Int], instructionPointer: inout Int, multiplies: inout Int) {
            switch action {
            case .set: program[left.register!] = right!.result(using: &program)
            case .mul:
                program[left.register!] = program[left.register!]! * right!.result(using: &program)
                multiplies += 1
            case .jump: if left.result(using: &program) != 0 { instructionPointer += right!.result(using: &program) } else { instructionPointer += 1 }
            case .sub: program[left.register!]! -= right!.result(using: &program)
            }
            
            switch action {
            case .jump: break
            default: instructionPointer += 1
            }
        }
        
        enum Action: String {
            case set
            case mul
            case jump = "jnz"
            case sub
        }
        
        enum Source {
            case register(String)
            case value(Int)
            
            init(_ string: Substring) {
                if let int = Int(string) {
                    self = .value(int)
                } else {
                    self = .register(String(string))
                }
            }
            
            func result(using program: inout [String: Int]) -> Int {
                switch self {
                case .value(let int): return int
                case .register(let string): return program[string]!
                }
            }
            
            var register: String? {
                switch self {
                case .register(let string): return string
                case .value: return nil
                }
            }
            
            var value: Int? {
                switch self {
                case .register: return nil
                case .value(let int): return int
                }
            }
        }
    }
}
