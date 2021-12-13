//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayThirteen(input: String, output: inout DayOutput) async {
//        let input = """
//        6,10
//        0,14
//        9,10
//        0,3
//        10,4
//        4,11
//        6,0
//        6,12
//        4,1
//        0,13
//        10,12
//        3,4
//        3,0
//        8,4
//        1,10
//        2,14
//        8,10
//        9,0
//
//        fold along y=7
//        fold along x=5
//        """

        let parts = input.components(separatedBy: "\n\n")
        let rawDots = parts[0].byLines().map { $0.byCommas().asInts() }.map(Point.init)
        let folds = parts[1].byLines().map { String($0.dropFirst(11)) }.map(Fold.init)

        var paper = Set(rawDots)

        for fold in folds {
            let toFold = paper.filter { fold.direction == .horizontal ? $0.x > fold.distance : $0.y > fold.distance }
            paper.subtract(toFold)
            let newDots = toFold.map { point -> Point in
                let distance = fold.distance
                return (fold.direction == .horizontal) ?
                    Point(distance - abs(distance - point.x), point.y) :
                    Point(point.x, distance - abs(distance - point.y))
            }
            paper.formUnion(newDots)

            if output.stepOne == nil {
                output.stepOne = "\(paper.count)"
            }
        }

        output.expectedStepOne = "837"

        output.stepTwo = """
        \n
        \(paper.asStringGrid())
        """
        output.expectedStepTwo = """


        #### ###  ####  ##  #  #  ##  #  # #  #
        #    #  #    # #  # # #  #  # #  # #  #
        ###  #  #   #  #    ##   #    #### #  #
        #    ###   #   # ## # #  #    #  # #  #
        #    #    #    #  # # #  #  # #  # #  #
        #### #    ####  ### #  #  ##  #  #  ##\u{20}

        """
    }
}

private struct Fold {
    enum Direction {
        case horizontal, vertical
    }

    let direction: Direction
    let distance: Int

    init(_ string: String) {
        let parts = string.components(separatedBy: "=")
        direction = (parts[0] == "x") ? .horizontal : .vertical
        distance = Int(parts[1])!
    }
}
