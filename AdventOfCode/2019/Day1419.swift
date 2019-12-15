//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1419: Day {
    override var expectedStageOneOutput: String? { nil }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() {
//        let input = String.input(forDay: 14, year: 2019)
        let input = """
        10 ORE => 10 A
        1 ORE => 1 B
        7 A, 1 B => 1 C
        7 A, 1 C => 1 D
        7 A, 1 D => 1 E
        7 A, 1 E => 1 FUEL
        """
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
        let fuel = reactions.first { $0.product.id == "FUEL" }!
        let ores = findOre(for: fuel.product, in: reactions)
        print(ores)
        print(ores.map { $0.quantity }.reduce(0, +))
    }

    func findOre(for reactant: Reactant, in reactions: [Reaction]) -> [Reactant] {
        guard reactant.id != "ORE" else { return [reactant] }

        let sourceReaction = reactions.first { $0.product.id == reactant.id }!
        let reactants = sourceReaction.reactants.map { newReactant -> Reactant in
            let multiplier = max(reactant.quantity / sourceReaction.product.quantity, 1)
            return Reactant(quantity: newReactant.quantity * multiplier, id: newReactant.id)
        }.flatMap { findOre(for: $0, in: reactions) }

        return reactants
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
