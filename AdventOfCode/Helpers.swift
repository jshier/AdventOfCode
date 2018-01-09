//
//  Helpers.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

extension String {
    static func input(forDay day: Int, year: Int = 2017) -> String {
        return try! String(contentsOfFile: "/Users/jshier/Desktop/Code/AdventOfCode/Inputs/\(year)/day\(day).txt")
    }
}
