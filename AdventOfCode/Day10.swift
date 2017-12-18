//
//  Day10.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/17/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day10: Day {
    override func perform() {
        let fileInput = String.input(forDay: 10)
        let fileLengths = fileInput.split(separator: ",").flatMap { Int($0) }
        let fileList = Array.countingUpTo(255)
        //let testLengths = [3, 4, 1, 5]
        let lengths = fileLengths
        //let testList = Array.countingUpTo(4)
        var list = fileList
        var currentPosition = 0
        
        for (skipSize, length) in lengths.enumerated() {
//            print("Skip Size: \(skipSize)")
//            print("Length: \(length)")
//            print("Current Position: \(currentPosition)")
            list.reverse(from: currentPosition, length: length)
            currentPosition = list.circularIndex(currentPosition, offsetBy: length + skipSize)
//            print("List: \(list)")
        }
        stageOneOutput = "\(list[0] * list[1])"
        
        let mixIns: [UInt32] = [17, 31, 73, 47, 23]
        
    }
}

//extension String {
//    func knotHash(lengths: [Int] = Array.countingUpTo(255)) -> String {
//        let mixIns: [UInt32] = [17, 31, 73, 47, 23]
//        var sequence = unicodeValues + mixIns
//        var currentPosition = 0
//        var skipSize = 0
//        for _ in 0..<64 {
//            for length in lengths {
//                sequence.reverse(from: currentPosition, length: length)
//                currentPosition = sequence.circularIndex(currentPosition, offsetBy: length + skipSize)
//                skipSize += 1
//            }
//        }
//
//
//    }
//}
//
//extension Array where Element == UInt32 {
//    var denseHash: [Int] {
//        precondition(count == 256)
//
//
//    }
//
//
//}

extension Array where Element == Int {
    static func countingUpTo(_ max: Int) -> [Int] {
        var array: [Int] = []
        array.reserveCapacity(max)
        for i in 0...max {
            array.append(i)
        }
        
        return array
    }
}

extension Array {
    mutating func reverse(from index: Index, length: Int) {
        guard length > 0 else { return }
        
        let sourceIndicies = circularIndicies(from: index, offsetBy: length - 1)
        var values = sourceIndicies.map { self[$0] }
        values.reverse()
        for (index, value) in sourceIndicies.enumerated() {
            self[value] = values[index]
        }
    }
    
    func circularIndicies(from: Index, offsetBy offset: Int) -> [Index] {
        guard offset > 0 else { return [from] }
        
        if from + offset >= endIndex {
            return (from..<endIndex).map { $0 } + circularIndicies(from: startIndex, offsetBy: from + offset - endIndex)
        } else {
            return (from...(from + offset)).map { $0 }
        }
    }
    
//    func partition(into: Int) -> [[Element]] {
//
//    }
}

extension Character {
    var unicodeValue: UInt32 {
        return unicodeScalars.first!.value
    }
}

extension String {
    var unicodeValues: [UInt32] {
        return map { $0.unicodeValue }
    }
}
