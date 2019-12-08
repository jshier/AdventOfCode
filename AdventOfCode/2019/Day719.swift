//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day719: Day {
    override var expectedStageOneOutput: String? { "298586" }
    override var expectedStageTwoOutput: String? { "9246095" }

    override func perform() {
        let input = String.input(forDay: 7, year: 2019)
//        let input = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
//        let input = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
        let original = input.byCommas().asInts()

        var greatestOutput = 0
        for permutation in [0, 1, 2, 3, 4].permutations() {
            let aOut = Day7Program(inputs: [permutation[0], 0], memory: original).execute()
            let bOut = Day7Program(inputs: [permutation[1], aOut], memory: original).execute()
            let cOut = Day7Program(inputs: [permutation[2], bOut], memory: original).execute()
            let dOut = Day7Program(inputs: [permutation[3], cOut], memory: original).execute()
            let eOut = Day7Program(inputs: [permutation[4], dOut], memory: original).execute()

            if eOut > greatestOutput {
                greatestOutput = eOut
            }
        }

        stageOneOutput = "\(greatestOutput)"

        var totals: [Int] = []
        for permutation in [5, 6, 7, 8, 9].permutations() {
            let a = Day7Program(inputs: [permutation[0], 0], memory: original, yieldOnOutput: true)
            let b = Day7Program(inputs: [permutation[1]], memory: original, yieldOnOutput: true)
            let c = Day7Program(inputs: [permutation[2]], memory: original, yieldOnOutput: true)
            let d = Day7Program(inputs: [permutation[3]], memory: original, yieldOnOutput: true)
            let e = Day7Program(inputs: [permutation[4]], memory: original, yieldOnOutput: true)

            while !e.halted {
                b.inputs.append(a.execute())
                c.inputs.append(b.execute())
                d.inputs.append(c.execute())
                e.inputs.append(d.execute())
                a.inputs.append(e.execute())
            }

            totals.append(e.output)
        }

        stageTwoOutput = "\(totals.max()!)"
    }
}

final class Day7Program {
    var inputs: [Int]
    private(set) var output = 0
    var memory: [Int]
    var ip = 0
    let yieldOnOutput: Bool

    private(set) var halted = false

    init(inputs: [Int], memory: [Int], yieldOnOutput: Bool = false) {
        self.inputs = inputs
        self.memory = memory
        self.yieldOnOutput = yieldOnOutput
    }

    func execute() -> Int {
        func modes(for instruction: Instruction, fromAllModes allModes: Int) -> [ParameterMode] {
            var allModes = allModes
            return (0..<instruction.neededModes)
                .map { _ in let value = allModes % 10; allModes /= 10; return value }
                .compactMap(ParameterMode.init(rawValue:))
        }

        loop: while true {
            let opCode = memory[ip]
            let instruction = Instruction(rawValue: opCode % 100)!
            let parameterModes = modes(for: instruction, fromAllModes: opCode / 100)
            var jumped = false

            ip += 1

            switch instruction {
            case .add:
                let parameters = zip(parameterModes, memory[ip...(ip + 1)]).map { $0.0.value(from: $0.1, appliedTo: memory) }

                memory[memory[ip + 2]] = parameters[0] + parameters[1]
            case .multiply:
                let parameters = zip(parameterModes, memory[ip...(ip + 1)]).map { $0.0.value(from: $0.1, appliedTo: memory) }

                memory[memory[ip + 2]] = parameters[0] * parameters[1]
            case .input:
                let first = inputs.removeFirst()
                memory[memory[ip]] = first
            case .output:
                output = zip(parameterModes, [memory[ip]]).map { $0.0.value(from: $0.1, appliedTo: memory) }.first!
                if yieldOnOutput {
                    if !jumped {
                        instruction.moveInstructionPointer(&ip)
                    }
                    break loop
                }
            case .jumpIfTrue:
                let parameters = zip(parameterModes, memory[ip...(ip + 1)]).map { $0.0.value(from: $0.1, appliedTo: memory) }
                if parameters[0] != 0 {
                    ip = parameters[1]
                    jumped = true
                }
            case .jumpIfFalse:
                let parameters = zip(parameterModes, memory[ip...(ip + 1)]).map { $0.0.value(from: $0.1, appliedTo: memory) }
                if parameters[0] == 0 {
                    ip = parameters[1]
                    jumped = true
                }
            case .lessThan:
                let parameters = zip(parameterModes, memory[ip...(ip + 1)]).map { $0.0.value(from: $0.1, appliedTo: memory) }
                memory[memory[ip + 2]] = (parameters[0] < parameters[1]) ? 1 : 0
            case .equals:
                let parameters = zip(parameterModes, memory[ip...(ip + 1)]).map { $0.0.value(from: $0.1, appliedTo: memory) }

                memory[memory[ip + 2]] = (parameters[0] == parameters[1]) ? 1 : 0
            case .exit:
                halted = true
                break loop
            case .crash:
                print("Crashing!")
                break loop
            }

            if !jumped {
                instruction.moveInstructionPointer(&ip)
            }
        }

        return output
    }

    enum Instruction: Int {
        case add = 1
        case multiply
        case input
        case output
        case jumpIfTrue
        case jumpIfFalse
        case lessThan
        case equals
        case exit = 99
        case crash = 0

        var neededModes: Int {
            switch self {
            case .add, .multiply, .jumpIfTrue, .jumpIfFalse, .lessThan, .equals: return 2
            case .input, .output: return 1
            default: return 0
            }
        }

        func moveInstructionPointer(_ ip: inout Int) {
            switch self {
            case .add, .multiply, .lessThan, .equals: ip += 3
            case .jumpIfTrue, .jumpIfFalse: ip += 2
            case .input, .output: ip += 1
            default: break
            }
        }
    }

    enum ParameterMode: Int {
        case position = 0
        case immediate

        func value(from initialValue: Int, appliedTo memory: [Int]) -> Int {
            switch self {
            case .position: return memory[initialValue]
            case .immediate: return initialValue
            }
        }
    }
}
