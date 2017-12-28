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
        
        let program0 = Program(lines: lines, id: 0)
        let program1 = Program(lines: lines, id: 1)
        program0.opposite = program1
        program1.opposite = program0
        program0.run()
        
        stageTwoOutput = "\(program1.sends)"
    }
    
    final class Program {
        private var registers: [String: Int] = [:]
        private var instructionPointer = 0
        private var queue: [Int] = []
        private var state: State = .ready
        
        private let instructions: [Instruction]
        private let id: Int
        
        var sends = 0
        weak var opposite: Program?
        
        init(lines: [Substring], id: Int) {
            self.id = id
            instructions = lines.map(Instruction.init)
        }
        
        subscript(register: String) -> Int {
            get {
                return registers[register, default: (register == "p") ? id : 0]
            }
            set {
                registers[register] = newValue
            }
        }
        
        func run() {
            guard !(state == .waiting && queue.isEmpty) else { terminate(); return }
            state = .running
            while state != .waiting {
                let instruction = instructions[instructionPointer]
                switch instruction.opCode {
                case .send: 
                    opposite?.enqueue(value: instruction.left.value(from: self))
                    sends += 1
                case .set: self[instruction.left.register!] = instruction.right!.value(from: self)
                case .multiply: self[instruction.left.register!] = self[instruction.left.register!] * instruction.right!.value(from: self)
                case .mod: self[instruction.left.register!] = self[instruction.left.register!] % instruction.right!.value(from: self)
                case .receive:
                    if queue.isEmpty {
                        state = .waiting
                        instructionPointer -= 1
                    } else {
                        self[instruction.left.register!] = queue.removeFirst()
                    }
                case .jump: if instruction.left.value(from: self) > 0 { instructionPointer += instruction.right!.value(from: self) - 1 }
                case .add: self[instruction.left.register!] += instruction.right!.value(from: self)
                }
                
                instructionPointer += 1
            }
            
            if state == .waiting { opposite?.run() }
        }
        
        func enqueue(value: Int) {
            queue.append(value)
        }
        
        func terminate() {
            guard state != .terminated else { return }
            
            state = .terminated
            opposite?.terminate()
        }
        
        enum State {
            case ready, running, waiting, terminated
        }
        
        struct Instruction {
            let opCode: OpCode
            let left: Source
            let right: Source?
            
            init(line: Substring) {
                let parts = line.split(separator: " ")
                opCode = OpCode(rawValue: String(parts[0]))!
                left = Source(parts[1])
                right = (parts.count == 3) ? Source(parts[2]) : nil
            }
            
            enum OpCode: String {
                case send = "snd"
                case set
                case multiply = "mul"
                case mod
                case receive = "rcv"
                case jump = "jgz"
                case add
            }
            
            enum Source {
                case register(String)
                case direct(Int)
                
                init(_ string: Substring) {
                    if let int = Int(string) {
                        self = .direct(int)
                    } else {
                        self = .register(String(string))
                    }
                }
                
                func value(from program: Program) -> Int {
                    switch self {
                    case .direct(let int): return int
                    case .register(let string): return program[string]
                    }
                }
                
                var register: String? {
                    switch self {
                    case .register(let string): return string
                    case .direct: return nil
                    }
                }
                
                var value: Int? {
                    switch self {
                    case .register: return nil
                    case .direct(let int): return int
                    }
                }
            }
        }
    }
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

