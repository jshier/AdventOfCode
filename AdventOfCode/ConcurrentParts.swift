//
//  ConcurrentParts.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/14/21.
//  Copyright © 2021 Jon Shier. All rights reserved.
//

func inParallel(part1: @Sendable @escaping () async -> String,
                part2: @Sendable @escaping () async -> String) async
    -> (stepOne: String, stepTwo: String) {
    async let p1 = part1()
    async let p2 = part2()

    return await (p1, p2)
}

func into<StepOne, StepTwo>(_ output: inout DayOutput,
                            part1: @Sendable @escaping () async -> StepOne,
                            part2: @Sendable @escaping () async -> StepTwo) async {
    async let p1 = part1()
    async let p2 = part2()

    output.stepOne = await "\(p1)"
    output.stepTwo = await "\(p2)"
}
