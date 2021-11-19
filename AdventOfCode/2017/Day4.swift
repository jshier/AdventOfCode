//
//  Day4.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/15/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day4: Day {
    override func perform() async {
        let input = String.input(forDay: 7, year: 2017)
        let lines = input.split(separator: "\n")
        let uniquePassphrases: Int = lines.map { line -> (Int, Int) in
            let words = line.split(separator: " ")
            let totalCount = words.count
            let uniqueCount = Set(words).count
            return (totalCount, uniqueCount)
        }
        .reduce(0) { result, element -> Int in
            (element.0 == element.1) ? result + 1 : result
        }

        let uniqueAnagramlessPhrases = lines.map { line -> Bool in
            let words = line.split(separator: " ")
            let totalCount = words.count
            let uniqueCount = Set(words).count

            guard totalCount == uniqueCount else { return false }

            var anagrams: [String: [String]] = [:]
            for word in words {
                let string = String(word)
                if var strings = anagrams[string.anagramKey] {
                    strings.append(string)
                    anagrams[string.anagramKey] = strings
                } else {
                    anagrams[string.anagramKey] = [string]
                }
                if anagrams[string.anagramKey]!.count > 1 { return false }
            }

            return true
        }
        .reduce(0) { result, element -> Int in
            element ? result + 1 : result
        }

        stageOneOutput = "\(uniquePassphrases)"
        stageTwoOutput = "\(uniqueAnagramlessPhrases)"
    }
}

extension String {
    var anagramKey: String {
        String(map { $0 }.sorted())
    }
}
