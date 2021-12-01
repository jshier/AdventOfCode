//
//  Day4.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/15/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

extension TwentySeventeen {
    func dayFour(_ output: inout DayOutput) async {
        let input = String.input(forDay: .four, year: .seventeen)
        let lines = input.byLines()
        let unique = lines.filter { line in
            let words = line.bySpaces()
            return Set(words).count == words.count
        }

        output.stepOne = "\(unique.count)"
        output.expectedStepOne = "383"

        let anagramless = unique.filter { line in
            let words = line.bySpaces()
            return Set(words.map(\.anagramKey)).count == words.count
        }

        output.stepTwo = "\(anagramless.count)"
        output.expectedStepTwo = "265"
    }
}

extension String {
    var anagramKey: String {
        String(sorted())
    }
}
