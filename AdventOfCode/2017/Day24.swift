//
//  Day24.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/24/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

final class Day24: Day {
    override func perform() {
        let fileInput = String.input(forDay: 24, year: 2017)
//        let testInput = """
//                        0/2
//                        2/2
//                        2/3
//                        3/4
//                        3/5
//                        0/1
//                        10/1
//                        9/10
//                        """
        let input = fileInput
        let components = input.split(separator: "\n").map(Component.init)
        let bridges = Bridge(components: []).build(using: components)
        let strengths = bridges.map { $0.strength }

        stageOneOutput = "\(strengths.max()!)"

        let strengthsAndLengths = bridges.map { LengthAndStrength(length: $0.length, strength: $0.strength) }

        stageTwoOutput = "\(strengthsAndLengths.max()!.strength)"
    }
}

struct LengthAndStrength: Equatable {
    let length: Int
    let strength: Int
}

extension LengthAndStrength: Comparable {
    static func < (lhs: LengthAndStrength, rhs: LengthAndStrength) -> Bool {
        if lhs.length == rhs.length {
            return lhs.strength < rhs.strength
        } else {
            return lhs.length < rhs.length
        }
    }
}

struct Bridge {
    let components: [Component]

    var availableValue: Int? {
        components.last?.availableValue
    }

    var strength: Int {
        components.map { $0.strength }.reduce(0, +)
    }

    var length: Int {
        components.count
    }

    func adding(_ component: Component) -> Bridge {
        var newComponents = components
        newComponents.append(component)
        return Bridge(components: newComponents)
    }

    func build(using availableComponents: [Component]) -> [Bridge] {
        var bridges: [Bridge] = []
        let usableComponents = availableComponents.filter { $0.contains(value: availableValue ?? 0) }
        for component in usableComponents {
            var availableComponents = availableComponents
            availableComponents.remove(at: availableComponents.firstIndex(of: component)!)
            let used = Component(component: component, using: availableValue ?? 0)
            let newBridge = adding(used)
            bridges.append(newBridge)
            let newBridges = newBridge.build(using: availableComponents)
            bridges.append(contentsOf: newBridges)
        }

        return bridges
    }
}

extension Bridge: CustomStringConvertible {
    var description: String {
        components.map { $0.description }.joined(separator: "--")
    }
}

struct Component: Equatable {
    let left: Port
    let right: Port
    let isRightUsed: Bool
    let isLeftUsed: Bool

    init(_ substring: Substring) {
        let ports = substring.split(separator: "/")
            .compactMap { Int($0) }
            .map(Port.init)
        left = ports[0]
        right = ports[1]
        isLeftUsed = false
        isRightUsed = false
    }

    init(left: Port, right: Port, isLeftUsed: Bool, isRightUsed: Bool) {
        self.left = left
        self.right = right
        self.isLeftUsed = isLeftUsed
        self.isRightUsed = isRightUsed
    }

    init(component: Component, using value: Int) {
        left = component.left
        right = component.right

        if left.value == value {
            isLeftUsed = true
            isRightUsed = false
        } else if right.value == value {
            isLeftUsed = false
            isRightUsed = true
        } else {
            fatalError("Didn't use a value.")
        }
    }

    func contains(value: Int) -> Bool {
        left.value == value || right.value == value
    }

    var availableValue: Int {
        if isRightUsed {
            return left.value
        } else {
            return right.value
        }
    }

    var strength: Int {
        left.value + right.value
    }
}

extension Component: CustomStringConvertible {
    var description: String {
        "\(left.value)/\(right.value)"
    }
}

struct Port {
    let value: Int

    init(_ value: Int) {
        self.value = value
    }
}

extension Port: Comparable {
    static func == (lhs: Port, rhs: Port) -> Bool {
        lhs.value == rhs.value
    }

    static func < (lhs: Port, rhs: Port) -> Bool {
        lhs.value < rhs.value
    }
}
