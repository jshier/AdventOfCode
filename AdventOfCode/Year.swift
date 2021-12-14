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
    let dayDuration: Double
    let absoluteDuration: Double

    var description: String {
        let stepOneCorrect = (dayOutput.stepOne != nil) && (dayOutput.stepOne == dayOutput.expectedStepOne)
        let stepTwoCorrect = (dayOutput.stepTwo != nil) && (dayOutput.stepTwo == dayOutput.expectedStepTwo)

        return """
        ========== Dec. \(day.rawValue), \(year.rawValue) ==========
        Step One: \(dayOutput.stepOne ?? "Incomplete.") \(stepOneCorrect ? "Correct!" : "Incorrect!")
        Step Two: \(dayOutput.stepTwo ?? "Incomplete.") \(stepTwoCorrect ? "Correct!" : "Incorrect!")
        Completed in: \(dayDuration)s, \(absoluteDuration) overall.
        """
    }
}

protocol Runner: AnyObject, Sendable {
    var year: Year { get }
    func dayOne(_ output: inout DayOutput) async
    func dayTwo(_ output: inout DayOutput) async
    func dayThree(_ output: inout DayOutput) async
    func dayFour(_ output: inout DayOutput) async
    func dayFive(_ output: inout DayOutput) async
    func daySix(_ output: inout DayOutput) async
    func daySeven(_ output: inout DayOutput) async
    func dayEight(_ output: inout DayOutput) async
    func dayNine(_ output: inout DayOutput) async
    func dayTen(_ output: inout DayOutput) async
    func dayEleven(_ output: inout DayOutput) async
    func dayTwelve(_ output: inout DayOutput) async
    func dayThirteen(input: String, output: inout DayOutput) async
    func dayFourteen(input: String, output: inout DayOutput) async
    func dayFifteen(_ output: inout DayOutput) async
    func daySixteen(_ output: inout DayOutput) async
    func daySeventeen(_ output: inout DayOutput) async
    func dayEighteen(_ output: inout DayOutput) async
    func dayNineteen(_ output: inout DayOutput) async
    func dayTwenty(_ output: inout DayOutput) async
    func dayTwentyOne(_ output: inout DayOutput) async
    func dayTwentyTwo(_ output: inout DayOutput) async
    func dayTwentyThree(_ output: inout DayOutput) async
    func dayTwentyFour(_ output: inout DayOutput) async
    func dayTwentyFive(_ output: inout DayOutput) async
}

extension Runner {
    func runAllDays() async {
        let start = CFAbsoluteTimeGetCurrent()
        var days: [YearOutput] = []
        for await day in NewDay.allCases.concurrentMapStream(performing: run) {
            print(day)
            days.append(day)
        }
        let end = CFAbsoluteTimeGetCurrent()

        let problemTime = days.map(\.dayDuration).sum
        let absoluteTime = days.map(\.absoluteDuration).sum
        let totalTime = end - start

        print("""
        Completed \(year) in \(totalTime)s total, \(absoluteTime)s absolute, and \(problemTime)s on problems.
        """)
    }

    @Sendable
    func run(_ day: NewDay) async -> YearOutput {
        let absoluteStart = CFAbsoluteTimeGetCurrent()
        let input = String.input(forDay: day, year: year)
        var output = DayOutput()
        let start = CFAbsoluteTimeGetCurrent()
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
            await dayThirteen(input: input, output: &output)
        case .fourteen:
            await dayFourteen(input: input, output: &output)
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
        return YearOutput(day: day,
                          year: year,
                          dayOutput: output,
                          dayDuration: end - start,
                          absoluteDuration: end - absoluteStart)
    }

    func dayOne(_ output: inout DayOutput) async {}
    func dayTwo(_ output: inout DayOutput) async {}
    func dayThree(_ output: inout DayOutput) async {}
    func dayFour(_ output: inout DayOutput) async {}
    func dayFive(_ output: inout DayOutput) async {}
    func daySix(_ output: inout DayOutput) async {}
    func daySeven(_ output: inout DayOutput) async {}
    func dayEight(_ output: inout DayOutput) async {}
    func dayNine(_ output: inout DayOutput) async {}
    func dayTen(_ output: inout DayOutput) async {}
    func dayEleven(_ output: inout DayOutput) async {}
    func dayTwelve(_ output: inout DayOutput) async {}
    func dayThirteen(input: String, output: inout DayOutput) async {}
    func dayFourteen(input: String, output: inout DayOutput) async {}
    func dayFifteen(_ output: inout DayOutput) async {}
    func daySixteen(_ output: inout DayOutput) async {}
    func daySeventeen(_ output: inout DayOutput) async {}
    func dayEighteen(_ output: inout DayOutput) async {}
    func dayNineteen(_ output: inout DayOutput) async {}
    func dayTwenty(_ output: inout DayOutput) async {}
    func dayTwentyOne(_ output: inout DayOutput) async {}
    func dayTwentyTwo(_ output: inout DayOutput) async {}
    func dayTwentyThree(_ output: inout DayOutput) async {}
    func dayTwentyFour(_ output: inout DayOutput) async {}
    func dayTwentyFive(_ output: inout DayOutput) async {}
}
