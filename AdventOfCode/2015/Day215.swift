//
//  Day215.swift
//  AdventOfCode
//
//  Created by Jon Shier on 1/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day215: Day {
    override func perform() {
        let input = String.input(forDay: 2, year: 2015)
        let presents = input.split(separator: "\n").map(Present.init)
        let totalArea = presents.map { $0.presentArea }.reduce(0, +)
        
        stageOneOutput = "\(totalArea)"
        
        let totalRibbon = presents.map { $0.ribbonLength }.reduce(0, +)
        
        stageTwoOutput = "\(totalRibbon)"
    }
    
    struct Present {
        let length: Int
        let width: Int
        let height: Int
        
        init(_ substring: Substring) {
            let lwh = substring.split(separator: "x").flatMap { Int($0) }
            length = lwh[0]
            width = lwh[1]
            height = lwh[2]
        }
        
        var sides: [Int] {
            let lw = length * width
            let lh = length * height
            let wh = width * height
            
            return [lw, lw, lh, lh, wh, wh]
        }
        
        var totalArea: Int {
            return sides.reduce(0, +)
        }
        
        var presentArea: Int {
            return totalArea + sides.min()!
        }
        
        var volume: Int {
            return length * width * height
        }
        
        var perimeters: [Int] {
            let lw = length + width
            let lh = length + height
            let wh = width + height
            
            return [lw * 2, lh * 2, wh * 2]
        }
        
        var smallestPerimeter: Int {
            return perimeters.min()!
        }
        
        var ribbonLength: Int {
            return smallestPerimeter + volume
        }
    }
}
