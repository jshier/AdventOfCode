//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation
import SwiftGraph

final class Day720: Day {
    override var expectedStageOneOutput: String? { "235" }
    override var expectedStageTwoOutput: String? { "158493" }

    override func perform() {
        let input = String.input(forDay: 7, year: 2020)
//        let input = """
//        shiny gold bags contain 2 dark red bags.
//        dark red bags contain 2 dark orange bags.
//        dark orange bags contain 2 dark yellow bags.
//        dark yellow bags contain 2 dark green bags.
//        dark green bags contain 2 dark blue bags.
//        dark blue bags contain 2 dark violet bags.
//        dark violet bags contain no other bags.
//        """
        let separated = input.byLines().map {
            $0
                .replacingOccurrences(of: "bags", with: "")
                .replacingOccurrences(of: "bag", with: "")
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: " , ", with: ",")
                .replacingOccurrences(of: "no other", with: "")
                .components(separatedBy: "contain")
                .map { $0.trimmingWhitespace() }
        }
        struct Contained: CustomStringConvertible {
            let color: String
            let quantity: Int

            var description: String { "\(quantity) \(color)" }

            init(_ string: String) {
                quantity = Int(string.prefix { $0.isASCII && $0.isWholeNumber })!
                color = String(string.drop { ($0.isASCII && $0.isWholeNumber) || $0.isWhitespace })
            }
        }
        let dicts: [[String: [Contained]]] = separated.map { Dictionary(dictionaryLiteral: ($0[0], $0[1].split(separator: ",").map(String.init).map(Contained.init))) }
        let bagMap: [String: [Contained]] = dicts.reduce(into: [:]) { result, subDict in
            result = result.merging(subDict, uniquingKeysWith: { $0 + $1 })
        }

        let graph = WeightedGraph<String, Int>(vertices: Array(bagMap.keys))
        bagMap.forEach { map in
            map.value.forEach { graph.addEdge(from: map.key, to: $0.color, weight: $0.quantity, directed: true) }
        }
        let pathsToGold = graph.vertices.map { graph.dfs(from: $0, to: "shiny gold") }.filter { !$0.isEmpty }

        stageOneOutput = "\(pathsToGold.count)"

        func bags(from origin: String) -> Int {
            guard let contained = bagMap[origin] else { return 0 }

            return contained.map { $0.quantity + bags(from: $0.color) * $0.quantity }.sum()
        }

        stageTwoOutput = "\(bags(from: "shiny gold"))"
    }
}
