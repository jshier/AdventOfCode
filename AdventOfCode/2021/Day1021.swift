//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import CoreFoundation

extension TwentyTwentyOne {
    func dayTen(_ output: inout DayOutput) async {
        let input = String.input(forDay: .ten, year: .twentyOne)
//        let input = """
//        [({(<(())[]>[[{[]{<()<>>
//        [(()[<>])]({[<{<<[]>>(
//        {([(<{}[<>[]}>{[]{[(<()>
//        (((({<>}<{<{<>}{[]{[]{}
//        [[<[([]))<([[{}[[()]]]
//        [{[{({}]{}}([{[{{{}}([]
//        {<[[]]>}<{[{[{[]{()[[[]
//        [<(<(<(<{}))><([]([]()
//        <{([([[(<>()){}]>(<<{{
//        <{([{{}}[<[[[<>{}]]]>[]]
//        """

        let lines = input.byLines().map { $0.compactMap(Delimiter.init) }

        var points = 0
        var incompletes: [[Delimiter]] = []
        outer: for line in lines {
            var pushed: [Delimiter] = []
            for character in line {
                if character.isOpener {
                    pushed.append(character)
                } else {
                    if character.opposite == pushed.last {
                        pushed.removeLast()
                    } else {
                        points += character.partOneScore
                        continue outer
                    }
                }
            }

            incompletes.append(pushed)
        }

        output.stepOne = "\(points)"
        output.expectedStepOne = "387363"

        let completions = incompletes.map {
            $0.map(\.opposite).reversed()
        }
        let scores: [Int] = completions.map { characters in
            characters.reduce(0) { iResult, character in
                (iResult * 5) + character.partTwoScore
            }
        }

        output.stepTwo = "\(scores.sorted().median)"
        output.expectedStepTwo = "4330777059"
    }
}

private enum Delimiter: Character {
    case oparen = "("
    case obrack = "["
    case obrace = "{"
    case oangle = "<"
    case cparen = ")"
    case cbrack = "]"
    case cbrace = "}"
    case cangle = ">"

    var opposite: Delimiter {
        switch self {
        case .oparen: return .cparen
        case .obrack: return .cbrack
        case .obrace: return .cbrace
        case .oangle: return .cangle
        case .cparen: return .oparen
        case .cbrack: return .obrack
        case .cbrace: return .obrace
        case .cangle: return .oangle
        }
    }

    var isOpener: Bool {
        switch self {
        case .oparen, .obrack, .obrace, .oangle: return true
        case .cparen, .cbrack, .cbrace, .cangle: return false
        }
    }

    var partOneScore: Int {
        switch self {
        case .oparen, .cparen: return 3
        case .obrack, .cbrack: return 57
        case .obrace, .cbrace: return 1197
        case .oangle, .cangle: return 25_137
        }
    }

    var partTwoScore: Int {
        switch self {
        case .oparen, .cparen: return 1
        case .obrack, .cbrack: return 2
        case .obrace, .cbrace: return 3
        case .oangle, .cangle: return 4
        }
    }
}
