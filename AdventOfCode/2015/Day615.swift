//
//  Day615.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/15/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day615: Day {
    override func perform() async {
        let fileInput = String.input(forDay: 6, year: 2015)
//        let testInput = """
//                        turn on 0,0 through 1,1
//                        toggle 0,0 through 1,0
//                        turn off 1,0 through 1,1
//                        """
        let input = fileInput
        let lights = Lights(input: input, size: 999)
        lights.setup()

        stageOneOutput = "\(lights.lightsLit)"
        stageTwoOutput = "\(lights.totalBrightness)"
    }

    final class Lights {
        let rules: [Rule]
        var state: [Point: Bool] = [:]
        var brightnessState: [Point: Int] = [:]

        var lightsLit: Int {
            state.values.count { $0 }
        }

        var totalBrightness: Int {
            brightnessState.values.reduce(0, +)
        }

        init(input: String, size: Int) {
            rules = input.split(separator: "\n").map(Rule.init)
            for point in PointSequence(start: Point(0, 0), end: Point(size, size)) {
                state[point] = false
                brightnessState[point] = 0
            }
        }

        func setup() {
            for rule in rules {
                for point in PointSequence(start: rule.start, end: rule.end) {
                    state[point] = rule.apply(to: state[point, default: false])
                    brightnessState[point] = rule.apply(to: brightnessState[point, default: 0])
                }
            }
        }

        struct Rule {
            let start: Point
            let end: Point
            let action: Action

            enum Action: Substring {
                case on = "turn on"
                case off = "turn off"
                case toggle
            }

            init(_ substring: Substring) {
                let sides = substring.components(separatedBy: " through ")

                let actionStart = sides[0].split(separator: " ")
                start = Point(actionStart.last!)
                end = Point(sides[1])
                action = (Action(rawValue: sides[0].prefix(6)) ?? Action(rawValue: sides[0].prefix(7)) ?? Action(rawValue: sides[0].prefix(8)))!
            }

            func apply(to bool: Bool) -> Bool {
                switch action {
                case .on: return true
                case .off: return false
                case .toggle: return !bool
                }
            }

            func apply(to int: Int) -> Int {
                switch action {
                case .on: return int + 1
                case .off: return (int == 0) ? 0 : (int - 1)
                case .toggle: return int + 2
                }
            }
        }
    }
}

extension Bool {
    func toggled() -> Bool {
        !self
    }

    mutating func toggle() {
        self = !self
    }
}
