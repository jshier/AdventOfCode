//
//  Day17.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/17/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day17: Day {
    override func perform() {
        let fileInput = 367
//        let testInput = 3
        let input = fileInput
        var buffer = [0]
        buffer.reserveCapacity(50_000_000)
        var currentValue = 1
        var insertedIndex = 0
        
        func insert(upTo value: Int) {
            while currentValue <= value {
                let circularIndex = buffer.circularIndex(insertedIndex, offsetBy: input)
                let insertionIndex = buffer.index(after: circularIndex)
                buffer.insert(currentValue, at: insertionIndex)
                currentValue += 1
                insertedIndex = insertionIndex
            }
        }
        
        insert(upTo: 2017)
        
        stageOneOutput = "\(buffer[buffer.index(after: insertedIndex)])"
        
        func endInsert(upTo value: Int) -> Int {
            var maxOneIndex = 0
            while currentValue <= value {
                let circularIndex = buffer.circularIndex(insertedIndex, offsetBy: input)
                let insertionIndex = buffer.index(after: circularIndex)
                buffer.append(currentValue)
                if insertionIndex == 1 {
                    print("Insertion index 1, updating to \(currentValue)")
                    maxOneIndex = currentValue
                }
                currentValue += 1
                insertedIndex = insertionIndex
            }
            
            return maxOneIndex
        }
        
        let maxOneIndex = endInsert(upTo: 50_000_000)

        stageTwoOutput = "\(maxOneIndex)"
    }
}
