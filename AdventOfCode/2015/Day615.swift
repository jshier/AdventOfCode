//
//  Day615.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/15/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyFifteen {
    func daySix(_ output: inout YearRunner.DayOutput) async {
        let fileInput = String.input(forDay: 6, year: 2015)
        //        let testInput = """
        //                        turn on 0,0 through 1,1
        //                        toggle 0,0 through 1,0
        //                        turn off 1,0 through 1,1
        //                        """
        let input = fileInput
        let lights = Lights(input: input, size: 999)
        lights.setup()

        output.stepOne = "\(lights.lightsLit)"
        output.expectedStepOne = "400410"
        output.stepTwo = "\(lights.totalBrightness)"
        output.expectedStepTwo = "15343601"
    }
}

private final class Lights {
    let rules: [Rule]
    var state: Grid<Bool>
    var brightnessState: Grid<Int>

    var lightsLit: Int {
        state.values.count { $0 }
    }

    var totalBrightness: Int {
        brightnessState.values.reduce(0, +)
    }

    init(input: String, size: Int) {
        rules = input.split(separator: "\n").map(Rule.init)
        state = Grid(Array(repeating: false, count: size * (size + 1)), height: size, width: size)
        brightnessState = Grid(Array(repeating: 0, count: size * (size + 1)), height: size, width: size)
    }

    func setup() {
        for rule in rules {
            for point in PointSequence(start: rule.start, end: rule.end) {
                state[point] = rule.apply(to: state[point])
                brightnessState[point] = rule.apply(to: brightnessState[point])
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
