//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation
import SE0270_RangeSet

final class Day220: Day {
    override var expectedStageOneOutput: String? { "517" }
    override var expectedStageTwoOutput: String? { "284" }

    override func perform() async {
        let input = String.input(forDay: 2, year: 2020)
        let separatedInput = input
            .byLines()
            .map { $0.split(separator: ":").map { String($0).trimmingWhitespace() } }

        struct Policy {
            let character: Character
            let range: ClosedRange<Int>

            init(_ string: String) {
                let parts = string.split(separator: " ")
                let bounds = parts[0].split(separator: "-").map(String.init).asInts()
                range = bounds[0]...bounds[1]
                character = Character(String(parts[1]))
            }

            func isValid(for string: String) -> Bool {
                range.contains(string.count(of: character))
            }
        }

        let policiesAndPasswords: [(Policy, Bool)] = separatedInput
            .map {
                let policy = Policy($0[0])
                return (policy, policy.isValid(for: $0[1]))
            }

        stageOneOutput = "\(policiesAndPasswords.count { $0.1 })"

        struct PositionPolicy {
            let character: Character
            let positions: RangeSet<Int>

            init(_ string: String) {
                let parts = string.split(separator: " ")
                let ints = parts[0]
                    .split(separator: "-")
                    .map(String.init)
                    .compactMap(Int.init)
                let indices = ints
                    .map { $0 - 1 }
                    .map { $0..<($0 + 1) }
                positions = RangeSet(indices)
                character = Character(String(parts[1]))
            }

            func isValid(for string: String) -> Bool {
                let slice = Array(string)[positions]

                return slice.count(of: character) == 1
            }
        }

        let newPoliciesAndPasswords: [(PositionPolicy, Bool)] = separatedInput
            .map {
                let policy = PositionPolicy($0[0])
                return (policy, policy.isValid(for: $0[1]))
            }

        stageTwoOutput = "\(newPoliciesAndPasswords.count { $0.1 })"
    }
}
