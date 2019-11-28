//
//  Day518.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/5/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day518: Day {
    override func perform() {
        let input = String.input(forDay: 5, year: 2018).byLines()[0]
//        let input = "dabAcCaCBAcCcaDA"
        let initialReaction = input.reacted()

        stageOneOutput = "\(initialReaction.count)"
        
        let shortest = "qwertyuiopasdfghjklzxcvbnm".map { (character) in input.filter { $0 != character && !$0.isOppositeCaseOf(character) } }
                                                   .map { $0.reacted() }
                                                   .min { $0.count < $1.count }!
        stageTwoOutput = "\(shortest.count)"
    }
}

private extension String {
    func reacted() -> String {
        var output = ""
        forEach {
            if output.last?.isOppositeCaseOf($0) == true {
                output.removeLast()
            } else {
                output.append($0)
            }
        }
        
        return output
    }
}

extension Character {
    func isOppositeCaseOf(_ character: Character) -> Bool {
        return abs(unicodeValue - character.unicodeValue) == 32
    }
}
