//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func dayTwenty(input: String, output: inout DayOutput) async {
//        let input = """
//        ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#
//
//        #..#.
//        #....
//        ##..#
//        ..#..
//        ..###
//        """

        let parts = input.components(separatedBy: "\n\n")
        let algorithm = Array(parts[0])
        let originalImage = Grid<Character>(parts[1].byLines().map(Array.init))

        var enhancedImage = InfiniteGrid(grid: originalImage, defaultElement: ".").values
        var newImage = enhancedImage
        var defaultElement: Character = "."

//        func value(forBlockIncluding point: Point) -> Int {
//            var points: [Point] = point.surroundingPoints
//            points.insert(point, at: 4)
//            return Array(points.reversed()).indexed().reduce(0) { result, indexPoint in
//                if enhancedImage[indexPoint.element, default: defaultElement] == "#" {
//                    return result + (1 << indexPoint.index)
//                } else {
//                    return result
//                }
//            }
        ////            let binary = points.reduce(into: "") { partialResult, point in
        ////                partialResult += enhancedImage[point, default: defaultElement] == "#" ? "1" : "0"
        ////            }
        ////            return Int(binary, radix: 2)!
//        }

        for step in 0..<50 {
            let (min, max) = Array(enhancedImage.keys).minAndMax()!
            let start = Point(min.x - 3, min.y - 3)
            let end = Point(max.x + 3, max.y + 3)

            let points = Array(PointSequence(start: start, end: end))
            for point in points {
                let allPoints = point.inclusiveSurroundingPoints
//                allPoints.insert(point, at: 4)
//                let string = allPoints.reduce(into: "") { partialResult, point in
//                    partialResult.append((enhancedImage[point, default: defaultElement] == "#") ? "1" : "0")
//                }
                var string = ""
//                for point in allPoints {
//                    string.append((enhancedImage[point, default: defaultElement] == "#") ? "1" : "0")
//                }
                string.append((enhancedImage[allPoints[0], default: defaultElement] == "#") ? "1" : "0")
                string.append((enhancedImage[allPoints[1], default: defaultElement] == "#") ? "1" : "0")
                string.append((enhancedImage[allPoints[2], default: defaultElement] == "#") ? "1" : "0")
                string.append((enhancedImage[allPoints[3], default: defaultElement] == "#") ? "1" : "0")
                string.append((enhancedImage[allPoints[4], default: defaultElement] == "#") ? "1" : "0")
                string.append((enhancedImage[allPoints[5], default: defaultElement] == "#") ? "1" : "0")
                string.append((enhancedImage[allPoints[6], default: defaultElement] == "#") ? "1" : "0")
                string.append((enhancedImage[allPoints[7], default: defaultElement] == "#") ? "1" : "0")
                string.append((enhancedImage[allPoints[8], default: defaultElement] == "#") ? "1" : "0")

                let index = Int(string, radix: 2)!
//                var index = 0
//                index += (enhancedImage[allPoints[0], default: defaultElement] == "#") ? 1 << 8 : 0
//                index += (enhancedImage[allPoints[1], default: defaultElement] == "#") ? 1 << 7 : 0
//                index += (enhancedImage[allPoints[2], default: defaultElement] == "#") ? 1 << 6 : 0
//                index += (enhancedImage[allPoints[3], default: defaultElement] == "#") ? 1 << 5 : 0
//                index += (enhancedImage[allPoints[4], default: defaultElement] == "#") ? 1 << 4 : 0
//                index += (enhancedImage[allPoints[5], default: defaultElement] == "#") ? 1 << 3 : 0
//                index += (enhancedImage[allPoints[6], default: defaultElement] == "#") ? 1 << 2 : 0
//                index += (enhancedImage[allPoints[7], default: defaultElement] == "#") ? 1 << 1 : 0
//                index += (enhancedImage[allPoints[8], default: defaultElement] == "#") ? 1 << 0 : 0

//                let index = allPoints.reversed().enumerated().reduce(into: 0) { partialResult, indexPoint in
//                    if enhancedImage[indexPoint.element, default: defaultElement] == "#" {
//                        return partialResult += (1 << indexPoint.offset)
//                    }
//                }
                newImage[point] = algorithm[index]
            }
            enhancedImage = newImage
            if algorithm[0] == "#" {
                defaultElement = (defaultElement == algorithm[0]) ? algorithm.last! : algorithm[0]
            }

            if step == 1 {
                output.stepOne = "\(enhancedImage.values.count { $0 == "#" })"
            }
        }

        output.expectedStepOne = "5479"

        output.stepTwo = "\(enhancedImage.values.count { $0 == "#" })"
        output.expectedStepTwo = "19012"
    }
}

private struct InfiniteGrid<Element> {
    private(set) var values: [Point: Element]
    private let defaultElement: Element

    var surroundingPoints: [Point] {
        let (min, max) = points.minAndMax()!
        let start = Point(min.x - 2, min.y - 2)
        let end = Point(max.x + 2, max.y + 2)

        return Array(PointSequence(start: start, end: end))
    }

    var points: [Point] {
        Array(values.keys)
    }

    init(grid: Grid<Element>, defaultElement: Element) {
        values = grid.points.reduce(into: [:]) { partialResult, point in
            partialResult[point] = grid[point]
        }
        self.defaultElement = defaultElement
    }

    subscript(_ point: Point) -> Element {
        get { values[point, default: defaultElement] }
        set { values[point] = newValue }
    }

    func block(including point: Point) -> [Element] {
        var points: [Point] = point.surroundingPoints.reversed()
        points.insert(point, at: 4)

        return points.map { values[$0, default: defaultElement] }
    }
}

private extension InfiniteGrid where Element == Character {
    func value(forBlockIncluding point: Point) -> Int {
        Int(block(including: point).map { ($0 == "#") ? "1" : "0" }.joined(), radix: 2)!
    }
}
