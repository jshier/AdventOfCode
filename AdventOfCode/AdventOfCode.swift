//
//  main.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

@_exported import Algorithms
@_exported import CollectionConcurrencyKit
@_exported import Collections
import CoreFoundation
@_exported import CountedSet
@_exported import IntegerUtilities
@_exported import Numerics
@_exported import SE0270_RangeSet
@_exported import SwiftGraph

@main
enum AdventOfCode {
    static func main() async {
        let year = TwentyTwentyOne()
//        await year.runAllDays()
        print(await year.run(.fourteen))
    }
}
