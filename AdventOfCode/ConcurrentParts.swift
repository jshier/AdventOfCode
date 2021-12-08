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
    let steps = [Task { await part1() },
                 Task { await part2() }]

    return await (steps[0].value, steps[1].value)
}

func into<StepOne, StepTwo>(_ output: inout DayOutput,
                            part1: @Sendable @escaping () async -> StepOne,
                            part2: @Sendable @escaping () async -> StepTwo) async {
    let steps = [Task { await "\(part1())" },
                 Task { await "\(part2())" }]

    output.stepOne = await steps[0].value
    output.stepTwo = await steps[1].value
}
