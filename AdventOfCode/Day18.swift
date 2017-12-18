//
//  Day18.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/17/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day18: Day {
    override func perform() {
        let fileInput = String.input(forDay: 18)
//        let testInput = """
//                        set a 1
//                        add a 2
//                        mul a a
//                        mod a 5
//                        snd a
//                        set a 0
//                        rcv a
//                        jgz a -1
//                        set a 1
//                        jgz a -2
//                        """
        let input = fileInput
        let lines = input.split(separator: "\n")
        let instructions = lines.map(Instruction.init)
        let registers = lines.map { String($0.split(separator: " ")[1]) }
        var program: [String: Int] = [:]
        registers.forEach { program[$0] = 0 }
        var instructionPointer = 0
        var mostRecentlyPlayedSound = 0
        var recoveredSound = 0
        
        while recoveredSound == 0 {
            instructions[instructionPointer].perform(on: &program,
                                                     instructionPointer: &instructionPointer,
                                                     mostRecentlyPlayedSound: &mostRecentlyPlayedSound,
                                                     recoveredSound: &recoveredSound)
        }
        
        stageOneOutput = "\(recoveredSound)"
    }
    
    struct Instruction {
        let action: Action
        let left: Source
        let right: Source?
        
        init(line: Substring) {
            let parts = line.split(separator: " ")
            action = Action(rawValue: String(parts[0]))!
            left = Source(parts[1])
            right = (parts.count == 3) ? Source(parts[2]) : nil
        }
        
        func perform(on program: inout [String: Int], instructionPointer: inout Int, mostRecentlyPlayedSound: inout Int, recoveredSound: inout Int) {
            switch action {
            case .playSound: mostRecentlyPlayedSound = left.result(using: &program)
            case .set: program[left.register!] = right!.result(using: &program)
            case .multiply: program[left.register!] = program[left.register!]! * right!.result(using: &program)
            case .mod: program[left.register!] = program[left.register!]! % right!.result(using: &program)
            case .recover: if left.result(using: &program) != 0 { recoveredSound = mostRecentlyPlayedSound }
            case .jump: if left.result(using: &program) > 0 { instructionPointer += right!.result(using: &program) } else { instructionPointer += 1 }
            case .add: program[left.register!]! += right!.result(using: &program)
            }

            switch action {
            case .jump: break
            default: instructionPointer += 1
            }
        }
        
        enum Action: String {
            case playSound = "snd"
            case set
            case multiply = "mul"
            case mod
            case recover = "rcv"
            case jump = "jgz"
            case add
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
    
    
    
//    struct Instruction {
//        let action: Action
//
//        init(line: Substring) {
//            let parts = line.split(separator: " ")
//            let rawAction = RawAction(rawValue: String(parts[0]))!
//            let register = String(parts[1])
//            let value = (parts.count == 3) ? String(parts[2]) : nil
//            let valueInt = value.flatMap { Int($0) }
//            switch rawAction {
//            case .playSound: action = .playSound(from: register)
//            case .set: action = .set(register, to: valueInt!)
//            case .multiply: action = .multiply(register, by: value!)
//            case .mod: action = .mod(to: register, by: valueInt!)
//            case .recover: action = .recover(from: register)
//            case .jump: action = .jump(register, by: valueInt!)
//            case .add: action = .add(valueInt!, to: register)
//            }
//        }
//
//        func perform(on program: inout [String: Int], instructionPointer: inout Int, mostRecentlyPlayedSound: inout Int, recoveredSound: inout Int) {
//            switch action {
//            case .playSound(let register): mostRecentlyPlayedSound = program[register]!
//            case .set(let register, let value): program[register] = value
//            case .multiply(let destination, let source): program[destination] = program[destination]! * program[source]!
//            case .mod(let register, let value): program[register] = program[register]! % value
//            case .recover(let register): if program[register]! != 0 { recoveredSound = mostRecentlyPlayedSound }
//            case .jump(let register, let value): if program[register]! > 0 { instructionPointer += value } else { instructionPointer += 1 }
//            case .add(let value, let register): program[register]! += value
//            }
//
//            switch action {
//            case .jump: break
//            default: instructionPointer += 1
//            }
//        }
//
//        enum Action {
//            case playSound(from: StringRegister)
//            case set(StringRegister, to: Int)
//            case multiply(StringRegister, by: StringRegister)
//            case mod(to: StringRegister, by: Int)
//            case recover(from: StringRegister)
//            case jump(StringRegister, by: Int)
//            case add(Int, to: StringRegister)
//        }
//
//        enum RawAction: String {
//            case playSound = "snd"
//            case set
//            case multiply = "mul"
//            case mod
//            case recover = "rcv"
//            case jump = "jgz"
//            case add
//        }
//
////        struct Register {
////            let name: String
////            let value: Int
////
////            init(name: String, value: Int = 0) {
////                self.name = name
////                self.value = value
////            }
////        }
//
//    }
    
    typealias StringRegister = String
}


