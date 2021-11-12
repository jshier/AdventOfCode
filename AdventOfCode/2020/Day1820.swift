//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1820: Day {
    override var expectedStageOneOutput: String? { "16332191652452" }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() {
        let input = String.input(forDay: 18, year: 2020)
        let equations = input.byLines()

        func evaluate(_ string: [Character], startingAt startIndex: Int) -> (result: Int, lastIndex: Int) {
            var result = 0
            var op: (Int, Int) -> Int = (+)
            var index = startIndex
            while index < string.endIndex {
                let jump: Int
                switch string[index] {
                case " ":
                    jump = 1
                case "+":
                    op = (+)
                    jump = 1
                case "*":
                    op = (*)
                    jump = 1
                case "(":
                    let (output, lastIndex) = evaluate(string, startingAt: index + 1)
                    result = op(result, output)
                    jump = (lastIndex - index) + 1
                case ")":
                    return (result: result, lastIndex: index)
                case let number where "0123456789".map { $0 }.contains(number):
                    result = op(result, Int(String(number))!)
                    jump = 1
                default:
                    fatalError()
                }

                index += jump
            }

            return (result: result, lastIndex: index)
        }

        let results = equations.map { evaluate($0.map { $0 }, startingAt: 0) }

        stageOneOutput = "\(results.map(\.result).sum())"

        func evaluateWithPrecedence(_ string: [Character], startingAt startIndex: Int) -> (result: Int, lastIndex: Int) {
            enum Element: Equatable {
                case number(Int)
                case add
                case multiply

                var value: Int? {
                    guard case let .number(value) = self else { return nil }

                    return value
                }
            }

            func evaluate(_ stack: [Element]) -> Int {
                var added: [Element] = []
                var index = 0
                while index < stack.endIndex {
                    let element = stack[index]
                    switch element {
                    case .add:
                        let left = added.popLast()!.value!
                        let right = stack[index + 1].value!
                        added.append(.number(left + right))
                        index += 2
                    case .multiply:
                        added.append(element)
                        index += 1
                    case .number:
                        added.append(element)
                        index += 1
                    }
                }

                return added.compactMap(\.value).product()
            }

            var stack: [Element] = []
            var index = startIndex
            while index < string.endIndex {
                let jump: Int
                switch string[index] {
                case " ":
                    jump = 1
                case "+":
                    stack.append(.add)
                    jump = 1
                case "*":
                    stack.append(.multiply)
                    jump = 1
                case "(":
                    let (output, lastIndex) = evaluateWithPrecedence(string, startingAt: index + 1)
                    stack.append(.number(output))
                    jump = (lastIndex - index) + 1
                case ")":
                    return (result: evaluate(stack), lastIndex: index)
                case let number where "0123456789".map { $0 }.contains(number):
                    stack.append(.number(Int(String(number))!))
                    jump = 1
                default:
                    fatalError()
                }

                index += jump
            }

            return (result: evaluate(stack), lastIndex: index)
        }

        let stageTwo = equations.map { evaluateWithPrecedence($0.map { $0 }, startingAt: 0) }

        stageTwoOutput = "\(stageTwo.map(\.result).sum())"
    }
}
