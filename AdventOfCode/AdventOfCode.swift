//
//  main.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

@_exported import Algorithms
@_exported import Collections
import CoreFoundation
@_exported import CountedSet
@_exported import Numerics
@_exported import SE0270_RangeSet
@_exported import SwiftGraph

@main
enum AdventOfCode {
    static func main() async {
        let fifteen = TwentyFifteen()
//        let start = CFAbsoluteTimeGetCurrent()
//        for await day in fifteen.runAllDays() {
//            print(day)
//        }
//        let end = CFAbsoluteTimeGetCurrent()
//        print("Overall Execution Time: \(end - start)s")
        print(await fifteen.run(.six))
    }
}