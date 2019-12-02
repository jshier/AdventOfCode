//
//  Day12.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day12: Day {
    override func perform() {
        let input = String.input(forDay: 12, year: 2017)
        let lines = input.split(separator: "\n")
        let separatedLines = lines.map { (line) -> [String: [String]] in
            let sides = line.components(separatedBy: " <-> ")
            return [sides[0]: sides[1].components(separatedBy: ", ")]
        }

        let reduced: [String: [String]] = separatedLines.reduce(into: [:]) { result, element in
            result[element.keys.first!] = element[element.keys.first!]
        }

        func connections(from key: String) -> Set<String> {
            var allConnections: Set<String> = []

            func insertConnections(from key: String) {
                let connections = reduced[key]!
                let unconnectedConnections = connections.filter { !allConnections.contains($0) }

                guard !unconnectedConnections.isEmpty else { return }

                unconnectedConnections.forEach { allConnections.insert($0) }

                unconnectedConnections.forEach { insertConnections(from: $0) }
            }

            insertConnections(from: key)

            return allConnections
        }

        let zeroConnections = connections(from: "0")
        stageOneOutput = "\(zeroConnections.count)"
        var totalGroups: [Set<String>] = [zeroConnections]
        let allPossibleGroups = Set(reduced.keys)
        var remainingGroups = allPossibleGroups.subtracting(zeroConnections)

        while let key = remainingGroups.first {
            let groupForKey = connections(from: key)
            totalGroups.append(groupForKey)
            remainingGroups.subtract(groupForKey)
        }

        stageTwoOutput = "\(totalGroups.count)"
    }
}
