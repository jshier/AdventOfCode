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
        let fileInput = String.input(forDay: 10, year: 2017)
        let fileLengths = fileInput.split(separator: ",").compactMap { Int($0) }
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
        stageTwoOutput = fileInput.knotHash()
    }
}

extension String {
    
    func rawKnotHash(input: [Int] = .countingUpTo(255)) -> [Int] {
        let mixIns = [17, 31, 73, 47, 23]
        let lengths = unicodeValues + mixIns
        var sequence = input
        var currentPosition = 0
        var skipSize = 0
        for _ in 0..<64 {
            for length in lengths {
                sequence.reverse(from: currentPosition, length: length)
                currentPosition = sequence.circularIndex(currentPosition, offsetBy: length + skipSize)
                skipSize += 1
            }
        }
        
        return sequence.denseHash
    }
    
    func knotHash(input: [Int] = .countingUpTo(255)) -> String {
        let hashed = rawKnotHash(input: input)
        return hashed.hexString
    }
}

extension Array where Element == Int {
    static func countingUpTo(_ max: Int) -> [Int] {
        var array: [Int] = []
        array.reserveCapacity(max)
        for i in 0...max {
            array.append(i)
        }
        
        return array
    }
    
    var denseHash: [Int] {
        precondition(count == 256)
        
        let parts = partition(into: 16)
        let xord = parts.map { Int($0.reduce(0, ^)) }
        return xord
    }
    
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
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
    
    /// This only works if the number of elements is evenly divisible by the requested number of partitions.
    func partition(into partitions: Int) -> [[Element]] {
        let partitionLength = count / partitions
        
        guard partitionLength > 0 else { return [self] }
        
        let pivots = partitions - 1
        
        guard pivots > 0 else { return [self] }
        
        var parts: [[Element]] = []
        for i in 0...pivots {
            parts.append(Array(self[(i * partitionLength)..<((i + 1) * partitionLength)]))
        }
        
        assert(parts.count == partitions, "Resulting array should have the requested number of elements.")
        //assert(parts.flatMap { $0 }.count == count, "Resulting arrays should contain all original items.")
        
        return parts
    }
}
