//
//  Day25.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/24/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day25: Day {
    override func perform() {
        let fileSteps = 12_317_297
//        let testSteps = 6
        let steps = fileSteps
        let tape = Tape(steps: steps)
        tape.perform()

        stageOneOutput = "\(tape.checksum())"
    }
}

final class Tape {
    private var tape: [Int: Bool] = [0: false]
    private var state = State.a
    private let steps: Int
    private var position = 0

    init(steps: Int) {
        self.steps = steps
    }

    func perform() {
        var stepsPerformed = 0
        while stepsPerformed < steps {
            state = state.perform(using: &tape[position, default: false], position: &position)
            stepsPerformed += 1
        }
    }

    func checksum() -> Int {
        tape.values.count { $0 == true }
    }
}

enum State {
    case a, b, c, d, e, f

    func perform(using value: inout Bool, position: inout Int) -> State {
        let originalValue = value
        value = mutate(value: value)
        position = move(from: position, using: originalValue)
        return nextState(using: originalValue)
    }

    private func mutate(value: Bool) -> Bool {
        switch value {
        case true:
            switch self {
            case .a, .b, .e, .f: return false
            case .c, .d: return true
            }
        case false:
            switch self {
            case .a, .b, .c, .e: return true
            case .d, .f: return false
            }
        }
    }

    private func move(from position: Int, using value: Bool) -> Int {
        switch value {
        case true:
            switch self {
            case .a, .c: return position - 1
            case .b, .d, .e, .f: return position + 1
            }
        case false:
            switch self {
            case .a, .b, .f: return position + 1
            case .c, .d, .e: return position - 1
            }
        }
    }

    private func nextState(using value: Bool) -> State {
        switch value {
        case true:
            switch self {
            case .a: return .d
            case .b: return .f
            case .c, .d: return .a
            case .e: return .b
            case .f: return .e
            }
        case false:
            switch self {
            case .a: return .b
            case .b: return .c
            case .c: return .c
            case .d: return .e
            case .e: return .a
            case .f: return .c
            }
        }
    }
}
