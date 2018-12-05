//
//  Day418.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/4/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day418: Day {
    override func perform() {
        let input = String.input(forDay: 4)
        let guardSleepMap = input.byLines()
                                 .sorted()
                                 .groupBy { $0.contains("Guard #") }
                                 .map(GuardShift.init)
                                 .reduce(into: [:]) { (result: inout [String: NSCountedSet], value) in
                                     let set = result[value.id, default: []]
                                     value.minutesAsleep.forEach { set.add($0) }
                                     result[value.id] = set
                                 }
        
        let mostAsleepGuard = guardSleepMap.max { $0.1.totalItemCounts() < $1.1.totalItemCounts() }!
        let mostAsleepMinute = mostAsleepGuard.value.map { ($0 as! Int, mostAsleepGuard.value.count(for: $0)) }
                                                    .sorted { $0.1 > $1.1 }
                                                    .first!.0
        stageOneOutput = "\(mostAsleepMinute * Int(mostAsleepGuard.key)!)"
        let guardWithGreatestSleepForMinute = guardSleepMap.max { $0.1.maxItemCount() < $1.1.maxItemCount() }!
        let secondMostAsleepMinute = guardWithGreatestSleepForMinute.value.map { ($0 as! Int, guardWithGreatestSleepForMinute.value.count(for: $0)) }
                                                                          .sorted { $0.1 > $1.1 }
                                                                          .first!.0
        stageTwoOutput = "\(secondMostAsleepMinute * Int(guardWithGreatestSleepForMinute.key)!)"
    }
    
    struct GuardShift {
        let id: String
        let startTime: String
        let asleepTimes: [String]
        let wakeTimes: [String]
        let minutesAsleep: [Int]
        
        init(_ strings: [String]) {
            precondition(strings[0].contains("Guard #"))
            id = String(strings[0].drop { $0 != "#" }
                                  .unicodeScalars
                                  .drop { !CharacterSet.decimalDigits.contains($0) }
                                  .prefix { CharacterSet.decimalDigits.contains($0) })
            startTime = String(strings[0].dropFirst()
                                         .prefix { $0 != "]" })
            let times = strings[1...]
            precondition(times.count % 2 == 0)
            asleepTimes = times.enumerated()
                               .filter { $0.offset % 2 == 0 }
                               .map { String($0.element.dropFirst().prefix { $0 != "]" }) }
            wakeTimes = times.enumerated()
                             .filter { $0.offset % 2 != 0 }
                             .map { String($0.element.dropFirst().prefix { $0 != "]" }) }
            minutesAsleep = zip(asleepTimes.map { $0.minute() }, wakeTimes.map { $0.minute() }).map(Range.init)
                                                                                               .flatMap { $0.map { $0 } }
        }
    }
}

private extension String {
    func minute() -> Int {
        return Int(String(drop { $0 != ":" }.dropFirst()))!
    }
}

extension NSCountedSet {
    func totalItemCounts() -> Int {
        return reduce(0) { $0 + count(for: $1) }
    }
    
    func maxItemCount() -> Int {
        return map { count(for: $0) }.max() ?? 0
    }
}

extension Sequence {
    func groupBy(_ predicate: (Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = []
        var intermediate: [Element] = []
        for element in self {
            if predicate(element) && !intermediate.isEmpty {
                result.append(intermediate)
                intermediate.removeAll(keepingCapacity: true)
            }
            
            intermediate.append(element)
        }
        if !intermediate.isEmpty {
            result.append(intermediate)
        }
        
        return result
    }
}
