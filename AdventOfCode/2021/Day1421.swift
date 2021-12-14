//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayFourteen(input: String, output: inout DayOutput) async {
//        let input = """
//        NNCB
//
//        CH -> B
//        HH -> N
//        CB -> H
//        NH -> C
//        HB -> C
//        HC -> B
//        HN -> C
//        NN -> C
//        BH -> H
//        NC -> B
//        NB -> B
//        BN -> B
//        BB -> N
//        BC -> B
//        CC -> N
//        CN -> C
//        """
        let parts = input.components(separatedBy: "\n\n")
        let template = parts[0]
        let rules: [String: String] = parts[1].byLines().reduce(into: [:]) { partialResult, rule in
            let parts = rule.components(separatedBy: " -> ")
            partialResult[parts[0]] = parts[1]
        }

        func minMaxDifference(in buckets: [String: Int]) -> Int {
            var counts: [Character: Int] = overallBuckets.reduce(into: [:]) { partialResult, keyValue in
                partialResult[keyValue.key.first!, default: 0] += keyValue.value
                partialResult[keyValue.key.last!, default: 0] += keyValue.value
            }
            counts[template.first!, default: 0] -= 1
            counts[template.last!, default: 0] -= 1

            counts = counts.mapValues { $0 / 2 }

            counts[template.first!, default: 0] += 1
            counts[template.last!, default: 0] += 1

            let minAndMax = counts.minAndMax { lhs, rhs in
                lhs.value < rhs.value
            }!

            return minAndMax.max.value - minAndMax.min.value
        }

        var overallBuckets: [String: Int] = template.windows(ofCount: 2).map(String.init).counted()

        for step in 0..<40 {
            var buckets: [String: Int] = [:]
            buckets.reserveCapacity(overallBuckets.count)

            for (pair, count) in overallBuckets {
                guard let insertion = rules[pair] else { buckets[pair, default: 0] += count; continue }

                buckets[String(pair.first!) + insertion, default: 0] += count
                buckets[insertion + String(pair.last!), default: 0] += count
            }

            overallBuckets = buckets

            if step == 9 {
                output.stepOne = "\(minMaxDifference(in: overallBuckets))"
            }
        }

        output.expectedStepOne = "3213"

        output.stepTwo = "\(minMaxDifference(in: overallBuckets))"
        output.expectedStepTwo = "3711743744429"
    }
}
