//
//  Day8.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/15/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

extension TwentySeventeen {
    func dayEight(_ output: inout DayOutput) async {
        let fileInput = String.input(forDay: .eight, year: .seventeen)
        //        let exampleInput = """
        //            b inc 5 if a > 1
        //            a inc 1 if b < 5
        //            c dec -10 if a >= 1
        //            c inc -20 if c == 10
        //            """
        let input = fileInput
        let lines = input.byLines()
        let instructions = lines.map(Instruction.init)
        let allRegisters = Set(instructions.map(\.register))
        var state = Dictionary(uniqueKeysWithValues: zip(allRegisters, Array(repeating: 0, count: allRegisters.count)))
        var largestValueEverSeen = 0
        for instruction in instructions {
            let evaluationRegister = instruction.condition.register
            let evaluationValue = state[evaluationRegister]!
            if instruction.condition.evaluate(evaluationValue) {
                let registerToModify = instruction.register
                let valueToModify = state[registerToModify]!
                let newValue = instruction.performAction(using: valueToModify)
                largestValueEverSeen = max(largestValueEverSeen, newValue)
                state[registerToModify] = newValue
            }
        }

        let largestValueInRegister = state.values.max()!
        output.stepOne = "\(largestValueInRegister)"
        output.expectedStepOne = "6343"
        output.stepTwo = "\(largestValueEverSeen)"
        output.expectedStepTwo = "7184"
    }

    private struct Instruction {
        let register: String
        let action: Action
        let amount: Int
        let condition: Condition

        init<S>(line: S) where S: StringProtocol {
            let split = line.components(separatedBy: " if ")
            let registerActionAmount = split[0].split(separator: " ")
            register = String(registerActionAmount[0])
            action = Action(rawValue: String(registerActionAmount[1]))!
            amount = Int(registerActionAmount[2])!
            condition = Condition(line: split[1])
        }

        func performAction(using initialValue: Int) -> Int {
            action.operation(initialValue, amount)
        }

        enum Action: String {
            case increase = "inc"
            case decrease = "dec"

            var operation: (Int, Int) -> Int {
                switch self {
                case .increase:
                    return (+)
                case .decrease:
                    return (-)
                }
            }
        }

        struct Condition {
            let register: String
            let comparison: Comparison
            let value: Int

            init(line: String) {
                let split = line.split(separator: " ")
                register = String(split[0])
                comparison = Comparison(rawValue: String(split[1]))!
                value = Int(split[2])!
            }

            func evaluate(_ input: Int) -> Bool {
                comparison.comparator(input, value)
            }

            enum Comparison: String {
                case greaterThan = ">"
                case lessThan = "<"
                case equalTo = "=="
                case lessThanOrEqualTo = "<="
                case greaterThanOrEqualTo = ">="
                case notEqual = "!="

                var comparator: (Int, Int) -> Bool {
                    switch self {
                    case .greaterThan: return (>)
                    case .lessThan: return (<)
                    case .equalTo: return (==)
                    case .greaterThanOrEqualTo: return (>=)
                    case .lessThanOrEqualTo: return (<=)
                    case .notEqual: return (!=)
                    }
                }
            }
        }
    }
}
