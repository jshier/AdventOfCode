//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayFour(_ output: inout DayOutput) async {
        let input = String.input(forDay: .four, year: .twentyOne)
//        let input = """
//        7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
//
//        22 13 17 11  0
//         8  2 23  4 24
//        21  9 14 16  7
//         6 10  3 18  5
//         1 12 20 15 19
//
//         3 15  0  2 22
//         9 18 13 17  5
//        19  8  7 25 23
//        20 11 10 24  4
//        14 21 16 12  6
//
//        14 21 17 24  4
//        10 16 15  9 19
//        18  8 23 26 20
//        22 11 13  6  5
//         2  0 12  3  7
//        """
        let lines = input.byLines()
        let draws = String(lines.first!).byCommas().asInts()
//        var boards = Array(lines.dropFirst())
//            .chunks(ofCount: 5)
//            .map(Array.init)
//            .map { $0.map { $0.bySpaces().asInts() } }
//            .map { Grid($0) }
//            .map(Board.init)

        var boards = Array(lines.dropFirst())
            .chunks(ofCount: 5)
            .map(Array.init)
            .map { $0.flatMap { $0.bySpaces().asInts() } }

//        var winningBoards: [Board] = []
//        var winningDraws: [Int] = []
//        for draw in draws {
//            for index in boards.indices {
//                guard !boards[index].isBingo else { continue }
//
//                if boards[index].select(draw) {
//                    winningBoards.append(boards[index])
//                    winningDraws.append(draw)
//                }
//            }
//        }
        var winningBoards: [[Int]] = []
        var winningIndices: Set<Int> = []
        var winningDraws: [Int] = []
        for draw in draws {
            for index in boards.indices {
                guard !winningIndices.contains(index) else { continue }

                guard let boardIndex = boards[index].firstIndex(of: draw) else { continue }

                boards[index][boardIndex] = -1

                let hasFullRow = boards[index].chunks(ofCount: 5).contains { $0.allSatisfy { $0 == -1 } }
                let hasFullColumn = (0..<5).map { boards[index].dropFirst($0).striding(by: 5).allSatisfy { $0 == -1 } }.contains(true)
                if hasFullRow || hasFullColumn {
                    winningBoards.append(boards[index])
                    winningDraws.append(draw)
                    winningIndices.insert(index)
                }
//                guard !boards[index].isBingo else { continue }
//
//                if boards[index].select(draw) {
//                    winningBoards.append(boards[index])
//                    winningDraws.append(draw)
//                }
            }
        }

//        output.stepOne = "\(winningBoards.first!.unmarkedValues.sum * winningDraws.first!)"
        output.stepOne = "\(winningBoards.first!.filter { $0 != -1 }.sum * winningDraws.first!)"
        output.expectedStepOne = "10374"
        output.stepTwo = "\(winningBoards.last!.filter { $0 != -1 }.sum * winningDraws.last!)"
//        output.stepTwo = "\(winningBoards.last!.unmarkedValues.sum * winningDraws.last!)"
        output.expectedStepTwo = "24742"
    }
}

private struct Board {
    let grid: Grid<Int>
    var selectedPoints: Set<Point> = []
    let columns: [Set<Point>]
    let rows: [Set<Point>]

    var isBingo: Bool {
        columns.map { selectedPoints.isSuperset(of: $0) }.contains(true) ||
            rows.map { selectedPoints.isSuperset(of: $0) }.contains(true)
    }

    var unmarkedValues: [Int] {
        grid.points.compactMap { selectedPoints.contains($0) ? nil : grid[$0] }
    }

    init(_ grid: Grid<Int>) {
        self.grid = grid
        columns = (0..<grid.width).map { x in Set((0..<grid.height).map { y in Point(x, y) }) }
        rows = (0..<grid.height).map { y in Set((0..<grid.height).map { x in Point(x, y) }) }
    }

    mutating func select(_ value: Int) -> Bool {
        guard let point = grid.point(forValue: value) else { return false }

        selectedPoints.insert(point)

        return isBingo
    }
}
