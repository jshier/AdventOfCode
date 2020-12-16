//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation
import StringDecoder

final class Day820: Day {
    override var expectedStageOneOutput: String? { "1317" }
    override var expectedStageTwoOutput: String? { "1033" }

    override func perform() {
        let input = String.input(forDay: 8, year: 2020)
        
        struct Instruction: Decodable, Equatable {
            enum Operation: String, Decodable {
                case acc, jmp, nop
            }
            
            let op: Operation
            let argument: Int
            
            var alternate: Instruction {
                switch op {
                case .acc: return self
                case .jmp: return .init(op: .nop, argument: argument)
                case .nop: return .init(op: .jmp, argument: argument)
                }
            }
        }
        
        let instructions: [Instruction] = input.byLines().map { line in
            let parts = line.split(separator: " ").map(String.init)
            let op = Instruction.Operation(rawValue: parts[0])!
            return Instruction(op: op, argument: Int(parts[1])!)
        }
        
        final class Runner {
            enum Result {
                case loop(Int)
                case finished(Int)
                case none
                
                var value: Int? {
                    switch self {
                    case let .loop(value), let .finished(value): return value
                    case .none: return nil
                    }
                }
            }
            
            private let instructions: [Instruction]
            private var accumulator: Int
            private var programCounter: Int
            private var executedIndices = Set<Int>()
            
            init(_ instructions: [Instruction],
                 initialProgramCounter: Int = 0,
                 initialAccumulator: Int = 0,
                 executedIndices: Set<Int> = []) {
                self.instructions = instructions
                programCounter = initialProgramCounter
                accumulator = initialAccumulator
                self.executedIndices = executedIndices
            }
            
            func runUntilDuplicate() -> Int {
                runUntilResult().value!
            }
            
            func runUntilResult() -> Result {
                while programCounter < instructions.count {
                    guard !executedIndices.contains(programCounter) else { return .loop(accumulator) }
                    
                    let instruction = instructions[programCounter]
                    let offset: Int
                    switch instruction.op {
                    case .acc:
                        offset = 1
                        accumulator += instruction.argument
                    case .jmp:
                        offset = instruction.argument
                    case .nop:
                        offset = 1
                    }
                    
                    executedIndices.insert(programCounter)
                    programCounter += offset
                }
                
                return .finished(accumulator)
            }
            
            func runAttemptingToAutocorrect() -> Result {
                for index in instructions.indices {
                    let instruction = instructions[index]
                    let alternate = instruction.alternate
                    
                    guard alternate != instruction else { continue }
                    
                    var correctedInstructions = instructions
                    correctedInstructions[index] = alternate
                    let runner = Runner(correctedInstructions)
                    let result = runner.runUntilResult()
                    
                    if case .finished = result {
                        return result
                    }
                }
                
                return .none
            }
        }
        
        let runner = Runner(instructions)
        let lastAccumulatorValue = runner.runUntilDuplicate()
        
        stageOneOutput = "\(lastAccumulatorValue)"

        let stageTwoRunner = Runner(instructions)
        let result = stageTwoRunner.runAttemptingToAutocorrect()

        stageTwoOutput = "\(result.value!)"
    }
}
