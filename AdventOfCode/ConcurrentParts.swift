//
//  ConcurrentParts.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/14/21.
//  Copyright © 2021 Jon Shier. All rights reserved.
//

func inParallel(part1: @escaping () async -> String, part2: @escaping () async -> String) async -> (stepOne: String, stepTwo: String) {
    await withTaskGroup(of: String.self, returning: (String, String).self) { group in
        group.addTask {
            await part1()
        }
        group.addTask {
            await part2()
        }

        return await (group.next()!, group.next()!)
    }
}
