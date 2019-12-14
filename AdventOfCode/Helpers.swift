//
//  Helpers.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import CommonCrypto
import CryptoKit
import Foundation

// MARK: - String

extension String {
    static func input(forDay day: Int, year: Int) -> String {
        try! String(contentsOfFile: "/Users/jshier/Desktop/Code/AdventOfCode/Inputs/\(year)/day\(day).txt")
    }

    func byLines() -> [String] {
        trimmingWhitespace().split(separator: "\n").map(String.init)
    }

    func byTabs() -> [String] {
        trimmingWhitespace().split(separator: "\t").map(String.init)
    }

    func bySpaces() -> [String] {
        trimmingWhitespace().split(separator: " ").map(String.init)
    }

    func byCommas() -> [String] {
        trimmingWhitespace().split(separator: ",").map(String.init)
    }

    func trimmingWhitespace() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    mutating func swapAt(_ first: Int, _ second: Int) {
        let firstIndex = index(startIndex, offsetBy: first)
        let secondIndex = index(startIndex, offsetBy: second)
        swapAt(firstIndex, secondIndex)
    }

    mutating func swapAt(_ first: Index, _ second: Index) {
        let firstString = String(self[first])
        let secondString = String(self[second])
        replaceSubrange(first..<index(after: first), with: secondString)
        replaceSubrange(second..<index(after: second), with: firstString)
    }

    mutating func filteringDestructive(_ token: Character) {
        var currentIndex = startIndex
        while currentIndex != endIndex {
            let character = self[currentIndex]
            if character == token {
                let nextIndex = index(after: currentIndex)
                removeSubrange(currentIndex...nextIndex)
            } else {
                currentIndex = index(after: currentIndex)
            }
        }
    }

    var unicodeValues: [Int] {
        map { $0.unicodeValue }
    }

    /// Extremely inefficient!
    subscript(index: Int) -> Character {
        self[self.index(startIndex, offsetBy: index)]
    }

    func md5Data() -> Data {
        Data(Insecure.MD5.hash(data: Data(utf8)))
    }

    func md5() -> String {
        md5Data().hexString
    }
}

extension Character {
    var unicodeValue: Int {
        Int(unicodeScalars.first!.value)
    }
}

// MARK: - Array

extension Array {
    mutating func insert(_ element: Element, after: Index) -> Index {
        let nextIndex = index(after: after)
        if nextIndex == endIndex {
            append(element)
        } else {
            insert(element, at: nextIndex)
        }

        return nextIndex
    }

    mutating func mutateForEach(_ body: (inout Element) throws -> Void) rethrows {
        var index = startIndex
        while index != endIndex {
            try body(&self[index])
            formIndex(after: &index)
        }
    }

    mutating func mapInPlace(_ transform: (Element) -> Element) {
        self = map(transform)
    }

    func decompose() -> (Element, [Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }

    func between(x: Element) -> [[Element]] {
        guard let (head, tail) = decompose() else { return [[x]] }
        return [[x] + self] + tail.between(x: x).map { [head] + $0 }
    }

    func permutations() -> [[Element]] {
        guard let (head, tail) = self.decompose() else { return [[]] }
        return tail.permutations().flatMap { $0.between(x: head) }
    }
}

extension Collection where Index == Int {
    func cycle() -> UnfoldSequence<Element, Int> {
        sequence(state: 0) { (index: inout Int) in
            let x = self[index]
            index = self.circularIndex(after: index)
            return x
        }
    }

    func circularIndex(_ from: Index, offsetBy offset: Int) -> Index {
        let potentialIndex = (from + offset) % count

        return (potentialIndex < 0) ? potentialIndex + endIndex : potentialIndex
    }

    func circularIndex(after: Index) -> Index {
        guard after < endIndex else { return 0 }

        return circularIndex(after, offsetBy: 1)
    }
}

extension Sequence where Element == Int {
    var asString: String {
        map(String.init).joined()
    }
}

extension Collection where Element: Comparable {
    func maxValueIndex() -> (value: Element, index: Index)? {
        guard !isEmpty else { return nil }

        var maxValue = first!
        var maxIndex = startIndex
        for (index, element) in zip(indices, self) {
            if element > maxValue {
                maxValue = element
                maxIndex = index
            }
        }

        return (value: maxValue, index: maxIndex)
    }
}

extension Collection where Element: Equatable {
    func allElementsEqual() -> Bool {
        guard !isEmpty else { return false }

        return allSatisfy { $0 == first }
    }
}

extension Collection {
    public func chunked(into size: Int) -> [SubSequence] {
        var chunks: [SubSequence] = []
        var i = startIndex

        while let nextIndex = index(i, offsetBy: size, limitedBy: endIndex) {
            let chunk = self[i..<nextIndex]
            chunks.append(chunk)
            i = nextIndex
        }

        if i != endIndex {
            chunks.append(self[i...])
        }

        return chunks
    }
}

extension Sequence {
    func count(where predicate: (Element) -> Bool) -> Int {
        var count = 0
        for element in self {
            if predicate(element) {
                count += 1
            }
        }

        return count
    }

    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}

extension Int {
    func lower16BitsEqual(lower16BitsOf int: Int) -> Bool {
        Int16(truncatingIfNeeded: self) == Int16(truncatingIfNeeded: int)
    }

    var paddedBinaryRepresentation: String {
        let string = String(self, radix: 2)
        let padding = String(repeating: "0", count: 8 - string.count)
        return padding + string
    }

    func greatestCommonDivisor(with other: Int) -> Int {
        if self == 0 { return other }

        return (other % self).greatestCommonDivisor(with: self)
    }

    func lowestCommonMultiple(with other: Int) -> Int {
        abs(self * other) / greatestCommonDivisor(with: other)
    }
}

extension Data {
    var hexString: String {
        map { String(format: "%02x", $0) }.joined()
    }
}

extension Array where Element == String {
    func asInts() -> [Int] {
        compactMap(Int.init)
    }

    func asDoubles() -> [Double] {
        compactMap(Double.init)
    }
}
