//
//  Day618.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/6/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day618: Day {
    override func perform() {
        let input = String.input(forDay: 6)
        let points = input.byLines().map(Point.init)
        print(points)
    }
}
