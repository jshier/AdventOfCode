//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1319: Day {
    override var expectedStageOneOutput: String? { "273" }
    override var expectedStageTwoOutput: String? { "13140" }

    override func perform() {
        let input = String.input(forDay: 13, year: 2019)
        let program = input.byCommas().asInts()
        let computer = IntcodeComputer(program: program, input: [])
        computer.execute()
        let outputs = computer.outputs.asOutput()

        let blocks = outputs.compactMap { $0.id }.count { $0 == .block }

        stageOneOutput = "\(blocks)"

        var freePlay = program
        freePlay[0] = 2
        let cabinet = ArcadeCabinet(program: freePlay)
        let highScore = cabinet.play()

        stageTwoOutput = "\(highScore)"
    }

    final class ArcadeCabinet {
        private let computer: IntcodeComputer
        private(set) var score = 0
        private(set) var screen: [Point: Output.Tile.ID] = [:]

        init(program: [Int]) {
            computer = IntcodeComputer(program: program, input: [0], yieldForInput: true)
        }

        func play() -> Int {
            loop: while !computer.isHalted {
                switch computer.execute() {
                case .exited:
                    let outputs = computer.outputs.asOutput()
                    score = outputs.compactMap { $0.score }.last ?? score
                    break loop
                case .needInput:
                    let outputs = computer.outputs.asOutput()
                    let ball = outputs.last { $0.id == .ball }!.tile!
                    let paddle = outputs.last { $0.id == .paddle }!.tile!
                    score = outputs.compactMap { $0.score }.last ?? score
                    outputs.compactMap { $0.tile }.forEach { screen[$0.point] = $0.id }

                    if ball.x < paddle.x {
                        computer.input.append(-1)
                    } else if ball.x == paddle.x {
                        computer.input.append(0)
                    } else if ball.x > paddle.x {
                        computer.input.append(1)
                    }
                    computer.outputs.removeAll(keepingCapacity: true)
                case .producedOutput, .crash: fatalError()
                }
//                printScreen()
            }

            return score
        }

        func printScreen() {
            let output = screen.print { id in
                switch id {
                case .empty: return " "
                case .wall: return "|"
                case .block: return "X"
                case .paddle: return "_"
                case .ball: return "O"
                }
            }
            print("---")
            print(output)
            print("---")
        }
    }

    enum Output {
        case tile(Tile)
        case score(Int)

        var tile: Tile? {
            if case let .tile(tile) = self { return tile }
            return nil
        }

        var x: Int? {
            if case let .tile(tile) = self { return tile.x }
            return nil
        }

        var y: Int? {
            if case let .tile(tile) = self { return tile.y }
            return nil
        }

        var id: Tile.ID? {
            if case let .tile(tile) = self { return tile.id }
            return nil
        }

        var score: Int? {
            if case let .score(score) = self { return score }
            return nil
        }

        init(x: Int, y: Int, tileID: Int) {
            if x == -1, y == 0 {
                self = .score(tileID)
            } else {
                self = .tile(Tile(x: x, y: y, id: Tile.ID(rawValue: tileID)!))
            }
        }

        struct Tile {
            let x: Int
            let y: Int
            let id: ID

            enum ID: Int {
                case empty, wall, block, paddle, ball
            }

            var point: Point { Point(x, y) }
        }
    }
}

private extension Array where Element == Int {
    func asOutput() -> [Day1319.Output] {
        stride(from: 0, to: count, by: 3).map {
            Day1319.Output(x: self[$0], y: self[$0 + 1], tileID: self[$0 + 2])
        }
    }
}
