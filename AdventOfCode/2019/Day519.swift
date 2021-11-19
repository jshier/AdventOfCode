//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day519: Day {
    override var expectedStageOneOutput: String? { "6745903" }
    override var expectedStageTwoOutput: String? { "9168267" }

    override func perform() async {
        let input = String.input(forDay: 5, year: 2019)
//        let input = "3,0,4,0,99"
//        let input = "1101,100,-1,4,0"
//        let input = "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
//        let input = "3,3,1107,-1,8,3,4,3,99"
//        let input = "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
        let values = input.byCommas().asInts()

        final class Program {
            let id: Int
            var memory: [Int]

            init(id: Int, memory: [Int]) {
                self.id = id
                self.memory = memory
            }

            func execute() -> Int {
                func modes(for instruction: Instruction, fromAllModes allModes: Int) -> [ParameterMode] {
                    var allModes = allModes
                    return (0..<instruction.neededModes)
                        .map { _ in let value = allModes % 10; allModes /= 10; return value }
                        .compactMap(ParameterMode.init(rawValue:))
                }

                var ip = 0
                var output = 0
                loop: while ip < memory.count {
//                    print(ip)
//                    print(memory)

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
                        memory[memory[ip]] = id
                    case .output:
                        output = zip(parameterModes, [memory[ip]]).map { $0.0.value(from: $0.1, appliedTo: memory) }.first!
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

        stageOneOutput = "\(Program(id: 1, memory: values).execute())"
        stageTwoOutput = "\(Program(id: 5, memory: values).execute())"
    }
}
