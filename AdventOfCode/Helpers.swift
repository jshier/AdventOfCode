//
//  Helpers.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Algorithms
import CommonCrypto
import CryptoKit
import Foundation
import IntegerUtilities
import SE0270_RangeSet

// MARK: - String

extension String {
    static func input(forDay day: Int, year: Int) -> String {
        try! String(contentsOfFile: "/Users/jshier/Desktop/Code/AdventOfCode/Inputs/\(year)/day\(day).txt")
            .trimmingWhitespace()
    }

    static func input(forDay day: NewDay, year: Year) -> String {
        try! String(contentsOfFile: "/Users/jshier/Desktop/Code/AdventOfCode/Inputs/\(year.rawValue)/day\(day.rawValue).txt")
            .trimmingWhitespace()
    }

    func byLines() -> [String] {
        trimmingWhitespace().split(separator: "\n").map(String.init)
    }

    func byParagraphs() -> [String] {
        trimmingWhitespace().components(separatedBy: "\n\n")
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
        map(\.unicodeValue)
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
        guard let (head, tail) = decompose() else { return [[]] }
        return tail.permutations().flatMap { $0.between(x: head) }
    }
}

extension Collection where Index == Int {
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
    func maxValueIndex() -> (index: Index, element: Element)? {
        indexed().max { $0.element < $1.element }
    }
}

extension Collection where Element: Equatable {
    func allElementsEqual() -> Bool {
        guard !isEmpty else { return false }

        return allSatisfy { $0 == first }
    }
}

extension Collection where Element: BinaryInteger, Index == Int {
    var median: Element {
        self[count / 2]
    }

    var average: Int {
        Int(sum) / count
    }
}

extension Collection {
    func chunked(into size: Int) -> [SubSequence] {
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

    func allPairs() -> LazyMapSequence<CombinationsSequence<Self>, (Self.Element, Self.Element)> {
        combinations(ofCount: 2).lazy.map { ($0[0], $0[1]) }
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

    func duplicateByElement(count: Int) -> [Element] {
        flatMap { repeatElement($0, count: count) }
    }

    func reduce<Result>(_ nextPartialResult: (_ partialResult: Result, Element) throws -> Result) rethrows -> Result? where Result == Element {
        var iterator = makeIterator()
        guard let initialResult = iterator.next() else { return nil }
        return try IteratorSequence(iterator).reduce(initialResult, nextPartialResult)
    }

    func reduce<Result>(_ nextPartialResult: (_ partialResult: inout Result, Element) throws -> Void) rethrows -> Result? where Result == Element {
        var iterator = makeIterator()
        guard let initialResult = iterator.next() else { return nil }
        return try IteratorSequence(iterator).reduce(into: initialResult, nextPartialResult)
    }

    func chaining<Other>(_ other: Other) -> Chain2Sequence<Self, Other> where Other: Sequence {
        chain(self, other)
    }

    func asArray() -> [Element] {
        Array(self)
    }
}

extension Sequence where Self: Sendable, Element: Sendable {
    func concurrentMapStream<T: Sendable>(performing closure: @escaping @Sendable (Element) async -> T) -> AsyncStream<T> {
        AsyncStream { continuation in
            Task {
                let maps = self.map { element in
                    Task { await closure(element) }
                }

                for map in maps {
                    continuation.yield(await map.value)
                }

                continuation.finish()
            }
        }
    }
}

extension Sequence where Element: Equatable {
    func count(of element: Element) -> Int {
        count { $0 == element }
    }
}

extension Sequence where Element: Comparable {
    func onMinAndMax<T>(_ perform: (_ min: Element, _ max: Element) -> T) -> T {
        let (min, max) = minAndMax()!
        return perform(min, max)
    }

    func onMaxAndMin<T>(_ perform: (_ max: Element, _ min: Element) -> T) -> T {
        let (min, max) = minAndMax()!
        return perform(max, min)
    }
}

extension Sequence where Element: AdditiveArithmetic {
    var sum: Element {
        reduce(Element.zero, +)
    }
}

extension Sequence where Element: Numeric {
    func product() -> Element {
        reduce(1, *)
    }
}

extension Int {
    func lower16BitsEqual(lower16BitsOf int: Int) -> Bool {
        Int16(truncatingIfNeeded: self) == Int16(truncatingIfNeeded: int)
    }

    var paddedBinaryRepresentation: String {
        binaryRepresentation(paddedToLength: 8)
    }

    func binaryRepresentation(paddedToLength length: Int) -> String {
        let string = String(self, radix: 2)
        let padding = String(repeating: "0", count: length - string.count)
        return padding + string
    }

    func greatestCommonDivisor(with other: Int) -> Int {
        if self == 0 { return other }

        return (other % self).greatestCommonDivisor(with: self)
    }

    func lowestCommonMultiple(with other: Int) -> Int {
        abs(self * other) / greatestCommonDivisor(with: other)
    }

    var vectorOffset: Int {
        signum()
    }

    var sum: Int {
        (self * (self + 1)) / 2
    }
}

func greatestCommonDivisor(_ lhs: Int, _ rhs: Int) -> Int {
    gcd(lhs, rhs)
}

func leastCommonMultiple(_ lhs: Int, _ rhs: Int) -> Int {
    abs(lhs * rhs) / greatestCommonDivisor(lhs, rhs)
}

func pow(_ lhs: Int, _ rhs: Int) -> Int {
    Int(pow(Double(lhs), Double(rhs)))
}

extension UInt8 {
    @usableFromInline
    var char: CChar {
        switch self {
        case 0..<10:
            return CChar(UInt8(ascii: "0") + self)
        default:
            precondition(self < 16)
            return CChar(UInt8(ascii: "a") + self - 10)
        }
    }
}

extension Collection where Element == UInt8, Index == Int {
    @inlinable
    var hexChars: [CChar] {
        var output = [CChar](repeating: 0, count: count * 2)
        for (i, byte) in enumerated() {
            output[i * 2 + 0] = ((byte >> 4) & 0xF).char
            output[i * 2 + 1] = ((byte >> 0) & 0xF).char
        }
        return output
    }

    @inlinable
    var hexString: String {
        String(fromUTF8: hexChars.map { UInt8($0) })
    }
}

public extension String {
    @inlinable
    init(fromUTF8 bytes: [UInt8]) {
        if let string = bytes.withContiguousStorageIfAvailable({ bptr in
            String(decoding: bptr, as: UTF8.self)
        }) {
            self = string
        } else {
            self = bytes.withUnsafeBufferPointer { ubp in
                String(decoding: ubp, as: UTF8.self)
            }
        }
    }
}

extension Sequence where Element == String {
    func asInts() -> [Int] {
        compactMap(Int.init)
    }

    func asDoubles() -> [Double] {
        compactMap(Double.init)
    }
}

extension String {
    func asInts() -> [Int] {
        map(String.init).asInts()
    }
}

extension Dictionary where Key == Point {
    func print(perElement: (_ element: Value) -> String) -> String {
        let (minX, maxX, minY, maxY) = keys.reduce((Int.max, Int.min, Int.max, Int.min)) { partialResult, point in
            (minX: Swift.min(partialResult.minX, point.x),
             maxX: Swift.max(partialResult.maxX, point.x),
             minY: Swift.min(partialResult.minY, point.y),
             maxY: Swift.max(partialResult.maxY, point.y))
        }

        var output = ""
        for y in minY...maxY {
            for x in minX...maxX {
                output += perElement(self[Point(x, y)]!)
            }
            output += "\n"
        }
        return output
    }
}

extension Set where Element == Point {
    func asStringGrid() -> String {
        let (minX, maxX, minY, maxY) = reduce((Int.max, Int.min, Int.max, Int.min)) { partialResult, point in
            (minX: Swift.min(partialResult.minX, point.x),
             maxX: Swift.max(partialResult.maxX, point.x),
             minY: Swift.min(partialResult.minY, point.y),
             maxY: Swift.max(partialResult.maxY, point.y))
        }

        var output = ""
        for y in minY...maxY {
            for x in minX...maxX {
                output += contains(.init(x, y)) ? "#" : " "
            }
            output += "\n"
        }
        return output
    }
}

extension Sequence where Element == Point {
    func print(lowestToHighest: Bool = true, perElement: (_ contained: Bool) -> String) -> String {
        let values = sorted()
        let minX = values.map(\.x).min()!
        let maxX = values.map(\.x).max()!
        let minY = values.map(\.y).min()!
        let maxY = values.map(\.y).max()!

        var output = ""
        for y in minY...maxY {
            for x in minX...maxX {
                output += perElement(values.contains(Point(x, y)))
            }
            output += "\n"
        }
        return (lowestToHighest ? output : output.split(separator: "\n").reversed().joined(separator: "\n"))
    }
}

extension Sequence where Element: Hashable {
    func counted() -> [Element: Int] {
        reduce(into: [:]) { partialResult, element in
            partialResult[element, default: 0] += 1
        }
    }
}
