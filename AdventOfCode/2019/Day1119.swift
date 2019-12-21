//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1119: Day {
    override var expectedStageOneOutput: String? { "2441" }
    override var expectedStageTwoOutput: String? {
        """
        \n
        ###  #### ###  #### ###  ###  #  #  ##
        #  #    # #  # #    #  # #  # # #  #  #
        #  #   #  #  # ###  #  # #  # ##   #
        ###   #   ###  #    ###  ###  # #  #
        #    #    # #  #    #    # #  # #  #  #
        #    #### #  # #    #    #  # #  #  ##
        \n
        """
    }

    override func perform() {
        let input = String.input(forDay: 11, year: 2019)
        let program = input.byCommas().asInts()

        let first = PaintingRobot(program: program, initialColor: .black)
        first.paint()

        stageOneOutput = "\(first.panels.keys.count)"

        let second = PaintingRobot(program: program, initialColor: .white)
        second.paint()

        var minX = Int.max
        var maxX = Int.min
        var minY = Int.max
        var maxY = Int.min

        for point in second.panels.keys {
            minX = min(minX, point.x)
            maxX = max(maxX, point.x)
            minY = min(minY, point.y)
            maxY = max(maxY, point.y)
        }

        var output = ""
        for y in (minY...maxY).reversed() {
            for x in minX...maxX {
                output.append((second.panels[Point(x, y), default: .black] == .black) ? " " : "#")
            }
            output.append("\n")
        }

        output = output.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: "\n")

        stageTwoOutput = """
        \n
        \(output)
        \n
        """
    }

    final class PaintingRobot {
        enum PanelColor: Int { case black, white }

        private(set) var panels: [Point: PanelColor]
        private var currentLocation = Point(0, 0)
        private var currentDirection = Direction.up
        private let brain: IntcodeComputer

        init(program: [Int], initialColor: PanelColor) {
            brain = IntcodeComputer(program: program, input: [initialColor.rawValue], yieldOnOutput: .yes(count: 2))
            panels = [Point(0, 0): initialColor]
        }

        func paint() {
            while true {
                brain.execute()

                guard !brain.isHalted else { break }

                let outputs = brain.outputs

                guard outputs.count == 2 else { fatalError() }

                brain.outputs = []
                let color = PanelColor(rawValue: outputs[0])!
                panels[currentLocation] = color
                currentDirection = (outputs[1] == 0) ? currentDirection.turn(.left) : currentDirection.turn(.right)
                currentLocation = currentLocation + currentDirection.forwardOffset
                brain.input = [panels[currentLocation, default: .black].rawValue]
            }
        }
    }
}

final class IntcodeComputer {
    var input: [Int]
    var output: Int? { outputs.last }
    var outputs: [Int] = []
    private(set) var isHalted = false

    private let program: [Int]
    private let originalMemory: [Int: Int]
    private var memory: [Int: Int]
    private var ip = 0
    private var relativeBase = 0
    private let yieldForInput: Bool
    private let yieldOnOutput: YieldOnOutput

    init(program: [Int], input: [Int], yieldForInput: Bool = false, yieldOnOutput: YieldOnOutput = .no) {
        self.program = program

        originalMemory = program.enumerated().reduce(into: [:]) { output, offsetElement in
            output[offsetElement.offset] = offsetElement.element
        }
        memory = program.enumerated().reduce(into: [:]) { output, offsetElement in
            output[offsetElement.offset] = offsetElement.element
        }
        self.input = input
        self.yieldForInput = yieldForInput
        self.yieldOnOutput = yieldOnOutput
    }

    subscript(_ i: Int) -> Int {
        get { memory[i, default: 0] }
        set { memory[i] = newValue }
    }

    subscript(_ range: ClosedRange<Int>) -> [Int] {
        range.map { self[$0] }
    }

    func reset() {
        ip = 0
        isHalted = false
        memory.removeAll(keepingCapacity: true)
        memory = originalMemory
    }

    @discardableResult
    func execute() -> ReturnCode {
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
                if yieldForInput && input.isEmpty {
                    ip -= (instruction.operations.count + 1)
                    return .needInput
                } else {
                    self[parameters[0]] = input.removeFirst()
                }
//                let value: Int
//                switch input {
//                case let .constant(constant):
//                    value = constant
//                case var .direct(inputs):
//                    value = inputs.removeFirst()
//                    input = .direct(inputs)
//                case .prompt:
//                    print("Enter input: ")
//                    value = readLine().flatMap { Int($0) }!
//                case .yield:
//                    break loop
//                }
//                self[parameters[0]] = value
            case .output:
                outputs.append(parameters[0])
                switch yieldOnOutput {
                case .no: continue
                case let .yes(count):
                    if outputs.count == count {
                        return .producedOutput
                    }
                }
            case .jumpIfTrue:
                if parameters[0] != 0 { ip = parameters[1] }
            case .jumpIfFalse:
                if parameters[0] == 0 { ip = parameters[1] }
            case .lessThan:
                self[parameters[2]] = (parameters[0] < parameters[1]) ? 1 : 0
            case .equals:
                self[parameters[2]] = (parameters[0] == parameters[1]) ? 1 : 0
            case .adjustRelativeBase:
                relativeBase += parameters[0]
            case .exit:
                isHalted = true
                return .exited
            case .crash:
                print("Crashing!")
                return .crash
            }
        }
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

    enum YieldOnOutput {
        case no
        case yes(count: Int)
    }

    enum ReturnCode {
        case exited, needInput, producedOutput, crash
    }

    enum Input {
        case constant(Int)
        case direct([Int])
        case prompt
        case yield(Int)
    }
}
