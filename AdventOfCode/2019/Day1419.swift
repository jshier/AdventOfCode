//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1419: Day {
    override var expectedStageOneOutput: String? { "337862" }
    override var expectedStageTwoOutput: String? { "3687786" }

    override func perform() async {
        let input = String.input(forDay: 14, year: 2019)
//        let input = """
//        10 ORE => 10 A
//        1 ORE => 1 B
//        7 A, 1 B => 1 C
//        7 A, 1 C => 1 D
//        7 A, 1 D => 1 E
//        7 A, 1 E => 1 FUEL
//        """
//        let input = """
//        9 ORE => 2 A
//        8 ORE => 3 B
//        7 ORE => 5 C
//        3 A, 4 B => 1 AB
//        5 B, 7 C => 1 BC
//        4 C, 1 A => 1 CA
//        2 AB, 3 BC, 4 CA => 1 FUEL
//        """

        let reactions = input.byLines().map(Reaction.init)
        let byProducts: [String: (quantity: Int, reactants: [Reactant])] = reactions.reduce(into: [:]) { output, reaction in
            output[reaction.product.id] = (reaction.product.quantity, reaction.reactants)
        }
        var surplus: [String: Int] = [:]

        func findOre(for id: String, quantity: Int) -> Int {
            guard id != "ORE" else { return quantity }

            guard quantity > surplus[id, default: 0] else {
                surplus[id, default: 0] -= quantity
                return 0
            }

            var quantity = quantity
            quantity -= surplus[id, default: 0]
            surplus[id] = 0
            var ore = 0
            let reaction = byProducts[id]!
            let copies = Int(ceil(Double(quantity) / Double(reaction.quantity)))

            for reactant in reaction.reactants {
                let amount = reactant.quantity * copies
                ore += findOre(for: reactant.id, quantity: amount)
            }
            surplus[id, default: 0] += (reaction.quantity * copies) - quantity

            return ore
        }

        stageOneOutput = "\(findOre(for: "FUEL", quantity: 1))"

        surplus.removeAll(keepingCapacity: true)

        var ore = 1_000_000_000_000
        var target = ore
        var fuel = 0
        var previousSurplus = surplus
        while (ore > 0) && (target > 0) {
            surplus = previousSurplus
            let oreUsed = findOre(for: "FUEL", quantity: target)
            if oreUsed > ore {
                target /= 2
            } else {
                fuel += target
                ore -= oreUsed
                previousSurplus = surplus
            }
        }

        stageTwoOutput = "\(fuel)"
    }

    struct Reactant {
        let quantity: Int
        let id: String
    }

    struct Reaction {
        let reactants: [Reactant]
        let product: Reactant
    }
}

private extension Day1419.Reactant {
    init(_ string: String) {
        let parts = string.split(separator: " ").map(String.init)
        quantity = Int(parts[0])!
        id = parts[1]
    }
}

private extension Day1419.Reaction {
    init(_ string: String) {
        let first = String(string.prefix { $0 != "=" })
        reactants = first.trimmingWhitespace().split(separator: ",").map(String.init).map { $0.trimmingWhitespace() }.map(Day1419.Reactant.init)
        let second = String(string.drop { $0 != ">" }.dropFirst(2))
        product = Day1419.Reactant(second)
    }
}
