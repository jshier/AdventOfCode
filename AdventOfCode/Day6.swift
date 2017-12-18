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
        let fileInput = String.input(forDay: 6)
        let fileBanks = fileInput.split(separator: "\t")
                                 .flatMap { Int($0) }
        //let testBanks = [0, 2, 7, 0]
        var banks = fileBanks
        var seen: Set<String> = [banks.asString]
        var redistributions = 0
        
        func redistribute() {
            var (value, index) = banks.maxValueIndex()!
            banks[index] = 0
            while value > 0 {
                index = banks.circularIndex(after: index)
                banks[index] += 1
                value -= 1
            }
        }
        
        func redistributeUntilDuplicate() -> String {
            while true {
                redistribute()
                redistributions += 1
                let banksString = banks.asString
                if seen.contains(banksString) {
                    return banksString
                } else {
                    seen.insert(banksString)
                }
            }
        }
        
        let firstDuplicate = redistributeUntilDuplicate()
        
        stageOneOutput = "\(redistributions)"
        
        seen.removeAll()
        seen.insert(banks.asString)
        
        redistributions = 0
        let secondDuplicate = redistributeUntilDuplicate()
        stageTwoOutput = "\(redistributions)"
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
    
    func circularIndex(after: Index) -> Index {
        let after = index(after: after)
        return (after == endIndex) ? startIndex : after
    }
}
