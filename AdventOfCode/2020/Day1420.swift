//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1420: Day {
    override var expectedStageOneOutput: String? { "13865835758282" }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() async {
        let input = String.input(forDay: 14, year: 2020)
//        let input = """
//        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
//        mem[8] = 11
//        mem[7] = 101
//        mem[8] = 0
//        """
//        let input = """
//        mask = 000000000000000000000000000000X1001X
//        mem[42] = 100
//        mask = 00000000000000000000000000000000X0XX
//        mem[26] = 1
//        """

        enum Action {
            case updateBitmask([(index: Int, value: Int)]) // I
            case writeMemory(location: Int, value: Int)

            init(_ string: String) {
                let parts = string.components(separatedBy: " = ")
                if parts[0] == "mask" {
                    self = .updateBitmask(parts[1].map { $0 }.reversed().indexed().map { tuple in
                        (index: tuple.index, element: Int(String(tuple.element)) ?? 2)
                    }
                    )
                } else {
                    let location = Int(parts[0].dropFirst(4).prefix { $0.isASCII && $0.isWholeNumber })!
                    let value = Int(parts[1])!
                    self = .writeMemory(location: location, value: value)
                }
            }
        }

        let actions = input.byLines().map(Action.init)

        struct State {
            var memory: [Int: Int] = [:]
            var currentBitmask: [(index: Int, value: Int)] = []

            var memorySum: Int {
                memory.values.sum()
            }

            mutating func applyStage1(_ action: Action) {
                switch action {
                case let .updateBitmask(bitmask):
                    currentBitmask = bitmask
                case let .writeMemory(location, value):
                    let newValue = currentBitmask.reduce(value) { result, value in
                        if value.value == 1 {
                            return result | (1 << value.index)
                        } else if value.value == 0 {
                            return result & ~(1 << value.index)
                        } else {
                            return result
                        }
                    }
                    memory[location] = newValue
                }
            }

            mutating func applyStage2(_ action: Action) {
                switch action {
                case let .updateBitmask(bitmask):
                    currentBitmask = bitmask
                case let .writeMemory(location, value):
                    let twosStart = currentBitmask.partition(by: { $0.value == 2 })
                    let processedLocation = currentBitmask[0..<twosStart].reduce(location) { result, maskValue in
                        if maskValue.value == 1 {
                            return result | (1 << maskValue.index)
                        } else if maskValue.value == 0 {
                            return result
                        } else {
                            fatalError()
                        }
                    }

                    let floatingLocations = currentBitmask[twosStart...].map { $0.index }
                    let locations: [Int] = floatingLocations.reduce(into: [processedLocation]) { locations, floatingIndex in
                        locations = locations.map { [$0 | (1 << floatingIndex), $0 & ~(1 << floatingIndex)] }.flatMap { $0 }
                    }

                    locations.forEach { memory[$0] = value }
                }
            }
        }

        var stageOneState = State()
        actions.forEach { stageOneState.applyStage1($0) }

        stageOneOutput = "\(stageOneState.memorySum)"

        var stageTwoState = State()
        actions.forEach { stageTwoState.applyStage2($0) }

        stageTwoOutput = "\(stageTwoState.memorySum)"
    }
}
