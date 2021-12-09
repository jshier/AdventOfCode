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
    // Make async if they ever fix the compiler crash, or the 5.6 toolchain starts working.
    static func main() async {
        let year = TwentyTwentyOne()
        // let start = CFAbsoluteTimeGetCurrent()
        // for await day in year.runAllDays() {
        //     print(day)
        // }
        // let end = CFAbsoluteTimeGetCurrent()
        // print("Overall Execution Time: \(end - start)s")
        print(await year.run(.nine))
    }
}
