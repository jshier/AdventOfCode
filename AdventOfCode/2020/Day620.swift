//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day620: Day {
    override var expectedStageOneOutput: String? { "7120" }
    override var expectedStageTwoOutput: String? { "3570" }

    override func perform() {
        let input = String.input(forDay: 6, year: 2020)
        let groupAnswers = input.byParagraphs()
        let answers = groupAnswers.map {
            $0.byLines().reduce(into: CountedSet<Character>()) { (output, answers) in
                answers.forEach { output.insert($0) }
            }
        }
        let numberOfQuestionsAnswered = answers.map { $0.count }.sum()
        
        stageOneOutput = "\(numberOfQuestionsAnswered)"
        
        let everyoneAnswers = groupAnswers.map {
            $0.byLines().map { line in
                line.reduce(into: CountedSet<Character>()) { output, character in
                    output.insert(character)
                }
            }
        }
        
        let union = everyoneAnswers.map {
            $0.dropFirst().reduce(into: $0[0]) { (output, set) in
                output = output.intersection(set)
            }
        }
        
        stageTwoOutput = "\(union.map { $0.count }.sum())"
    }
}
