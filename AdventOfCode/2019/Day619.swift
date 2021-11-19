//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation
import SwiftGraph

final class Day619: Day {
    override var expectedStageOneOutput: String? { "162816" }
    override var expectedStageTwoOutput: String? { "304" }

    override func perform() async {
        let input = String.input(forDay: 6, year: 2019)
//        let input = """
//        COM)B
//        B)C
//        C)D
//        D)E
//        E)F
//        B)G
//        G)H
//        D)I
//        E)J
//        J)K
//        K)L
//        """
        let values = input.byLines()

        let graph = WeightedGraph<String, Int>()
        values.forEach {
            let sides = $0.split(separator: ")").map(String.init)
            sides.forEach { _ = graph.addVertex($0) }
            graph.addEdge(from: sides[0], to: sides[1], weight: 1)
        }

        stageOneOutput = "\(graph.allConnectionsCount())"

        stageTwoOutput = "\(graph.bfs(from: "YOU", to: "SAN").count - 2)"
    }
}

extension WeightedGraph where V == String, W == Int {
    func allConnectionsCount() -> Int {
        dijkstra(root: "COM", startDistance: 0).0.compactMap { $0 }.reduce(0, +)
    }
}
