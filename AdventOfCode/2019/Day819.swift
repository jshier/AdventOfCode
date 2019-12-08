//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day819: Day {
    override var expectedStageOneOutput: String? { "1806" }
    override var expectedStageTwoOutput: String? {
        """
        
          11  11  1111 111   11  
           1 1  1 1    1  1 1  1 
           1 1  1 111  1  1 1  1 
           1 1111 1    111  1111 
        1  1 1  1 1    1 1  1  1 
         11  1  1 1    1  1 1  1 
        
        """
    }

    override func perform() {
        let input = String.input(forDay: 8, year: 2019)

        let width = 25
        let height = 6

        let layers = input.trimmingWhitespace().chunked(into: width * height)

        let zeroCounts = layers.map { ($0, $0.count(where: { $0 == "0" })) }.sorted { $0.1 < $1.1 }

        stageOneOutput = "\(zeroCounts[0].0.count { $0 == "1" } * zeroCounts[0].0.count { $0 == "2" })"

        let rawOutput = layers.reduce(into: Array(repeating: "2", count: width * height)) { result, substring in
            for (index, element) in substring.enumerated() {
                if result[index] == "2" && element != "2" {
                    result[index] = String(element)
                }
            }
        }

        stageTwoOutput = "\n\(rawOutput.joined().replacingOccurrences(of: "0", with: " ").chunked(into: width).joined(separator: "\n"))\n"
    }
}
