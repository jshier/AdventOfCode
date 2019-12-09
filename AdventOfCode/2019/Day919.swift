//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day919: Day {
    override var expectedStageOneOutput: String? { "3780860499" }
    override var expectedStageTwoOutput: String? { "33343" }

    override func perform() {
        let input = String.input(forDay: 9, year: 2019)
//        let input = "104,1125899906842624,99"
//        let input = "1102,34915192,34915192,7,4,7,99,0"
//        let input = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
        let memory = input.byCommas().asInts()
        let program = Day9Program(inputs: [1], memory: memory)
        let output = program.execute()

        stageOneOutput = "\(output.first!)"

        stageTwoOutput = "\(Day9Program(inputs: [2], memory: memory).execute().first!)"
    }
}

final class Day9Program {
    var inputs: [Int]
    private(set) var outputs: [Int] = []
    var memory: [Int: Int]
    var ip = 0
    var relativeBase = 0
    let yieldOnOutput: Bool

    private(set) var halted = false

    init(inputs: [Int], memory: [Int], yieldOnOutput: Bool = false) {
        self.inputs = inputs
        self.memory = memory.enumerated().reduce(into: [:]) { output, offsetElement in
            output[offsetElement.offset] = offsetElement.element
        }
        self.yieldOnOutput = yieldOnOutput
    }

    subscript(_ i: Int) -> Int {
        get { memory[i, default: 0] }
        set { memory[i] = newValue }
    }

    subscript(_ range: ClosedRange<Int>) -> [Int] {
        range.map { self[$0] }
    }

    func execute() -> [Int] {
        loop: while true {
            let opCode = self[ip]
            let instruction = Instruction(rawValue: opCode % 100)!

            ip += 1

            var modes = opCode / 100
            var parameters: [Int] = []
            for (i, operation) in instruction.operations.enumerated() {
                let mode = Mode(rawValue: modes % 10)!
                let value = self[ip + i]
                switch mode {
                case .position:
                    switch operation {
                    case .read: parameters.append(self[value])
                    case .write: parameters.append(value)
                    }
                case .immediate:
                    if operation == .write { fatalError() }
                    parameters.append(value)
                case .relative:
                    switch operation {
                    case .read: parameters.append(self[value + relativeBase])
                    case .write: parameters.append(value + relativeBase)
                    }
                }
                modes /= 10
            }

            ip += instruction.operations.count

            switch instruction {
            case .add:
                self[parameters[2]] = parameters[0] + parameters[1]
            case .multiply:
                self[parameters[2]] = parameters[0] * parameters[1]
            case .input:
                let input = inputs.removeFirst()
                self[parameters[0]] = input
            case .output:
                outputs.append(parameters[0])
                if yieldOnOutput {
                    break loop
                }
            case .jumpIfTrue:
                if parameters[0] != 0 {
                    ip = parameters[1]
                }
            case .jumpIfFalse:
                if parameters[0] == 0 {
                    ip = parameters[1]
                }
            case .lessThan:
                self[parameters[2]] = (parameters[0] < parameters[1]) ? 1 : 0
            case .equals:
                self[parameters[2]] = (parameters[0] == parameters[1]) ? 1 : 0
            case .adjustRelativeBase:
                relativeBase += parameters[0]
            case .exit:
                halted = true
                break loop
            case .crash:
                print("Crashing!")
                break loop
            }
        }

        return outputs
    }

    enum Instruction: Int {
        case add = 1
        case multiply = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case adjustRelativeBase = 9
        case exit = 99
        case crash = 0

        var operations: [Operation] {
            switch self {
            case .add, .multiply, .lessThan, .equals: return [.read, .read, .write]
            case .input: return [.write]
            case .output, .adjustRelativeBase: return [.read]
            case .jumpIfTrue, .jumpIfFalse: return [.read, .read]
            case .exit, .crash: return []
            }
        }
    }

    enum Operation {
        case read, write
    }

    enum Mode: Int {
        case position = 0
        case immediate
        case relative
    }
}
