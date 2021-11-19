//
//  Day.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/12/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

class Day {
    var stageOneOutput: String?
    var stageTwoOutput: String?

    var expectedStageOneOutput: String? { nil }
    var expectedStageTwoOutput: String? { nil }

    func perform() async {
        print("Must override perform in subclasses.")
    }

    func output() async -> String {
        let startTime = CFAbsoluteTimeGetCurrent()
        await perform()
        let endTime = CFAbsoluteTimeGetCurrent()

        let stageOneCorrect = (stageOneOutput == (expectedStageOneOutput ?? "Fallback")) ? "Correct!" : "Incorrect!"
        let stageTwoCorrect = (stageTwoOutput == (expectedStageTwoOutput ?? "Fallback")) ? "Correct!" : "Incorrect!"
        let elapsed = "\(endTime - startTime)s"

        return """
        ========== \(type(of: self)) ==========
        Stage 1: \(stageOneOutput ?? "No output.") \(stageOneCorrect)
        Stage 2: \(stageTwoOutput ?? "No output.") \(stageTwoCorrect)
        Completed in: \(elapsed)
        """
    }
}
