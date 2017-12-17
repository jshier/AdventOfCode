//
//  Day6.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/16/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day6: Day {
    override func perform() {
//        let fileInput = String.input(forDay: 6)
//        let fileBanks = fileInput.split(separator: "\t")
//                                 .flatMap { Int($0) }
        let testBanks = [0, 2, 7, 0]
        var banks = testBanks
        var seen: Set<String> = [testBanks.asString]
        var redistributions = 0
        func redistribute() {
            let (value, index) = banks.maxValueIndex()!
            var blocks = value
            banks[index] = 0
            while blocks > 0 {
                
            }
        }
        
    }
}

extension Array where Element == Int {
    var asString: String {
        return map(String.init).joined()
    }
    
    func maxValueIndex() -> (value: Element, index: Index)? {
        guard !isEmpty else { return nil }
        
        var maxValue = first!
        var maxIndex = startIndex
        for (index, element) in self.enumerated() {
            if element > maxValue {
                maxValue = element
                maxIndex = index
            }
        }
        
        return (value: maxValue, index: maxIndex)
    }
}
