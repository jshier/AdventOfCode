//
//  Year.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/14/21.
//  Copyright © 2021 Jon Shier. All rights reserved.
//

import CoreFoundation

enum Year: Int, CaseIterable {
    case fifteen = 2015
    case sixteen = 2016
    case seventeen = 2017
    case eighteen = 2018
    case nineteen = 2019
    case twenty = 2020
    case twentyOne = 2021
}

enum NewDay: Int, CaseIterable {
    case one = 1
    case two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen,
         seventeen, eighteen, nineteen, twenty, twentyOne, twentyTwo, twentyThree, twentyFour, twentyFive
}

extension NewDay: CustomStringConvertible {
    var description: String { "\(rawValue)" }
}

enum YearRunner {
    typealias DayParts = (day: NewDay, parts: Parts)
    typealias Parts = (partOne: String?, partTwo: String?)

    struct DayOutput {
        var stepOne: String?
        var stepTwo: String?
        var expectedStepOne: String?
        var expectedStepTwo: String?
    }

    struct YearOutput: CustomStringConvertible {
        let day: NewDay
        let year: Year
        let dayOutput: DayOutput
        let duration: Double

        var description: String {
            let stepOneCorrect = (dayOutput.stepOne != nil) && (dayOutput.stepOne == dayOutput.expectedStepOne)
            let stepTwoCorrect = (dayOutput.stepTwo != nil) && (dayOutput.stepTwo == dayOutput.expectedStepTwo)

            return """
            ========== Dec. \(day.rawValue), \(year.rawValue) ==========
            Step One: \(dayOutput.stepOne ?? "Incomplete.") \(stepOneCorrect ? "Correct!" : "Incorrect!")
            Step Two: \(dayOutput.stepTwo ?? "Incomplete.") \(stepTwoCorrect ? "Correct!" : "Incorrect!")
            Completed in: \(duration)s
            """
        }
    }
}

protocol Runner: AnyObject {
    var year: Year { get }
    func dayOne(_ output: inout YearRunner.DayOutput) async
    func dayTwo(_ output: inout YearRunner.DayOutput) async
    func dayThree(_ output: inout YearRunner.DayOutput) async
    func dayFour(_ output: inout YearRunner.DayOutput) async
    func dayFive(_ output: inout YearRunner.DayOutput) async
    func daySix(_ output: inout YearRunner.DayOutput) async
    func daySeven(_ output: inout YearRunner.DayOutput) async
    func dayEight(_ output: inout YearRunner.DayOutput) async
    func dayNine(_ output: inout YearRunner.DayOutput) async
    func dayTen(_ output: inout YearRunner.DayOutput) async
    func dayEleven(_ output: inout YearRunner.DayOutput) async
    func dayTwelve(_ output: inout YearRunner.DayOutput) async
    func dayThirteen(_ output: inout YearRunner.DayOutput) async
    func dayFourteen(_ output: inout YearRunner.DayOutput) async
    func dayFifteen(_ output: inout YearRunner.DayOutput) async
    func daySixteen(_ output: inout YearRunner.DayOutput) async
    func daySeventeen(_ output: inout YearRunner.DayOutput) async
    func dayEighteen(_ output: inout YearRunner.DayOutput) async
    func dayNineteen(_ output: inout YearRunner.DayOutput) async
    func dayTwenty(_ output: inout YearRunner.DayOutput) async
    func dayTwentyOne(_ output: inout YearRunner.DayOutput) async
    func dayTwentyTwo(_ output: inout YearRunner.DayOutput) async
    func dayTwentyThree(_ output: inout YearRunner.DayOutput) async
    func dayTwentyFour(_ output: inout YearRunner.DayOutput) async
    func dayTwentyFive(_ output: inout YearRunner.DayOutput) async
}

extension Runner {
    func runAllDays() -> AsyncStream<YearRunner.YearOutput> {
        AsyncStream { continuation in
            Task {
                await withTaskGroup(of: YearRunner.YearOutput.self) { group in
                    for day in NewDay.allCases {
                        group.addTask { await self.run(day) }
                    }

                    for await output in group {
                        continuation.yield(output)
                    }

                    continuation.finish()
                }
            }
        }
    }

    func run(_ day: NewDay) async -> YearRunner.YearOutput {
        let start = CFAbsoluteTimeGetCurrent()
        var output = YearRunner.DayOutput()
        switch day {
        case .one:
            await dayOne(&output)
        case .two:
            await dayTwo(&output)
        case .three:
            await dayThree(&output)
        case .four:
            await dayFour(&output)
        case .five:
            await dayFive(&output)
        case .six:
            await daySix(&output)
        case .seven:
            await daySeven(&output)
        case .eight:
            await dayEight(&output)
        case .nine:
            await dayNine(&output)
        case .ten:
            await dayTen(&output)
        case .eleven:
            await dayEleven(&output)
        case .twelve:
            await dayTwelve(&output)
        case .thirteen:
            await dayThirteen(&output)
        case .fourteen:
            await dayFourteen(&output)
        case .fifteen:
            await dayFifteen(&output)
        case .sixteen:
            await daySixteen(&output)
        case .seventeen:
            await daySeventeen(&output)
        case .eighteen:
            await dayEighteen(&output)
        case .nineteen:
            await dayNineteen(&output)
        case .twenty:
            await dayTwenty(&output)
        case .twentyOne:
            await dayTwentyOne(&output)
        case .twentyTwo:
            await dayTwentyTwo(&output)
        case .twentyThree:
            await dayTwentyThree(&output)
        case .twentyFour:
            await dayTwentyFour(&output)
        case .twentyFive:
            await dayTwentyFive(&output)
        }
        let end = CFAbsoluteTimeGetCurrent()
        return YearRunner.YearOutput(day: day, year: year, dayOutput: output, duration: end - start)
    }

    func dayOne(_ output: inout YearRunner.DayOutput) async {}
    func dayTwo(_ output: inout YearRunner.DayOutput) async {}
    func dayThree(_ output: inout YearRunner.DayOutput) async {}
    func dayFour(_ output: inout YearRunner.DayOutput) async {}
    func dayFive(_ output: inout YearRunner.DayOutput) async {}
    func daySix(_ output: inout YearRunner.DayOutput) async {}
    func daySeven(_ output: inout YearRunner.DayOutput) async {}
    func dayEight(_ output: inout YearRunner.DayOutput) async {}
    func dayNine(_ output: inout YearRunner.DayOutput) async {}
    func dayTen(_ output: inout YearRunner.DayOutput) async {}
    func dayEleven(_ output: inout YearRunner.DayOutput) async {}
    func dayTwelve(_ output: inout YearRunner.DayOutput) async {}
    func dayThirteen(_ output: inout YearRunner.DayOutput) async {}
    func dayFourteen(_ output: inout YearRunner.DayOutput) async {}
    func dayFifteen(_ output: inout YearRunner.DayOutput) async {}
    func daySixteen(_ output: inout YearRunner.DayOutput) async {}
    func daySeventeen(_ output: inout YearRunner.DayOutput) async {}
    func dayEighteen(_ output: inout YearRunner.DayOutput) async {}
    func dayNineteen(_ output: inout YearRunner.DayOutput) async {}
    func dayTwenty(_ output: inout YearRunner.DayOutput) async {}
    func dayTwentyOne(_ output: inout YearRunner.DayOutput) async {}
    func dayTwentyTwo(_ output: inout YearRunner.DayOutput) async {}
    func dayTwentyThree(_ output: inout YearRunner.DayOutput) async {}
    func dayTwentyFour(_ output: inout YearRunner.DayOutput) async {}
    func dayTwentyFive(_ output: inout YearRunner.DayOutput) async {}
}
