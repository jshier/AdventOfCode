//
//  Day24.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/24/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

final class Day24: Day {
    override func perform() {
//        let fileInput = String.input(forDay: 24)
        let testInput = """
                        0/2
                        2/2
                        2/3
                        3/4
                        3/5
                        0/1
                        10/1
                        9/10
                        """
        let input = testInput
        let components = input.split(separator: "\n").map(Component.init)
        print(components)
    }
}

struct Component {
    let left: Port
    let right: Port
    
    init(_ substring: Substring) {
        let ports = substring.split(separator: "/")
                             .flatMap { Int($0) }
                             .map(Port.init)
        left = ports[0]
        right = ports[1]
    }
}

extension Component: CustomStringConvertible {
    var description: String {
        return "\(left.value)/\(right.value)"
    }
}

struct Port {
    let value: Int
    var isUsed = false
    
    init(_ value: Int) {
        self.value = value
    }
}
