//
//  Day515.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/9/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day515: Day {
    override func perform() {
        let fileInput = String.input(forDay: 5, year: 2015)
//        let testInput = """
//                        ugknbfddgicrmopn
//                        aaa
//                        jchzalrnumimnmhp
//                        haegwjzuvuyypxyu
//                        dvszwmarrgswjxmb
//                        """
        let input = fileInput
        let strings = input.split(separator: "\n")
        let niceCount = strings.count { $0.isNice }
        
        stageOneOutput = "\(niceCount)"
    }
}

extension StringProtocol {
    var isNice: Bool {
        var vowelCount = 0
        let vowels = "aeiou"
        let disallowed = ["ab", "cd", "pq", "xy"]
        var doubleLetter = false
        var currentIndex = startIndex
        while currentIndex != endIndex {
            if vowels.contains(self[currentIndex]) {
                vowelCount += 1
            }
            
            let nextIndex = index(after: currentIndex)
            
            if nextIndex != endIndex {
                guard !disallowed.contains("\(self[currentIndex])\(self[nextIndex])") else { return false }
                
                if self[currentIndex] == self[nextIndex] {
                    doubleLetter = true
                }
            }
            
            currentIndex = index(after: currentIndex)
        }
        
        return (vowelCount >= 3) && doubleLetter
    }
    
    var isNiceComplex: Bool {
        return false
    }
}
