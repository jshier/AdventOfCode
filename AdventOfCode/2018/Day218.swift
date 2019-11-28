//
//  Day218.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/1/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day218: Day {
    override func perform() {
        let input = String.input(forDay: 2, year: 2018)
        let lines = input.byLines()
        var sets: [NSCountedSet] = []
        for line in lines {
            let set = NSCountedSet()
            line.forEach { set.add($0) }
            sets.append(set)
        }
        let hasTwo = sets.count { (set) in
            set.count { set.count(for: $0) == 2 } > 0
        }
        let hasThree = sets.count { (set) in
            set.count { set.count(for: $0) == 3 } > 0
        }
        stageOneOutput = "\(hasTwo * hasThree)"

        var dropping = lines.dropFirst()
        var largestSimilarity: String?
        loop: for firstLine in lines {
            for secondLine in dropping {
                var differences = 0
                var similar = ""
                for pair in zip(firstLine, secondLine) {
                    guard differences <= 1 else { break }
                    
                    if pair.0 != pair.1 {
                        differences += 1
                    } else {
                        similar.append(pair.0)
                    }
                }
                
                if similar.count == secondLine.count - 1 { largestSimilarity = similar; break loop }
            }
            dropping = dropping.dropFirst()
        }
        stageTwoOutput = largestSimilarity
    }
}
