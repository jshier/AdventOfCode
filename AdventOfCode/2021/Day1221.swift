//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import CountedSet

extension TwentyTwentyOne {
    func dayTwelve(_ output: inout DayOutput) async {
        let input = String.input(forDay: .twelve, year: .twentyOne)
//        let input = """
//        start-A
//        start-b
//        A-c
//        A-b
//        b-d
//        A-end
//        b-end
//        """
//        let input = """
//        dc-end
//        HN-start
//        start-kj
//        dc-start
//        dc-HN
//        LN-dc
//        HN-end
//        kj-sa
//        kj-HN
//        kj-dc
//        """
        let connections = input.byLines().map { Connection($0.split(separator: "-").map(String.init)) }
        let caves: [Cave: Set<Cave>] = connections.reduce(into: [:]) { partialResult, connection in
            var left = partialResult[connection.left, default: []]
            left.insert(connection.right)
            partialResult[connection.left] = left
            var right = partialResult[connection.right, default: []]
            right.insert(connection.left)
            partialResult[connection.right] = right
        }

        func findAllPaths(from cave: Cave, alreadyVisited: [Cave]) -> [[Cave]] {
            guard !(cave == .small("end")) else { return [alreadyVisited + [cave]] }

            let destinations = caves[cave, default: []].filter { $0.isLarge || !alreadyVisited.contains($0) }

            let newVisited = alreadyVisited + [cave]

            guard !destinations.isEmpty else { return [newVisited] }

            return destinations.flatMap { findAllPaths(from: $0, alreadyVisited: newVisited) }
        }

        let paths = findAllPaths(from: .small("start"), alreadyVisited: []).filter { $0.last?.name == "end" }

        output.stepOne = "\(paths.count)"
        output.expectedStepOne = "4549"

//        func findAllPathsModified(from cave: Cave, alreadyVisited: [Cave: Int]) async -> [[Cave: Int]] {
//            var alreadyVisited = alreadyVisited
//            guard cave != .small("end") else { alreadyVisited[cave] = 1; return [alreadyVisited] }
//
//            let destinations = caves[cave, default: []].filter { destination in
//                if destination.name == "start" { return false }
//
//                if destination.isLarge { return true }
//
//                if alreadyVisited[destination] == nil { return true }
//
//                let smallCounts = alreadyVisited.count { visitedCave, count in
//                    !visitedCave.isLarge && (count == 2 || visitedCave == cave)
//                }
//
//                return smallCounts == 0
//            }
//
//            alreadyVisited[cave, default: 0] += 1
//
//            guard !destinations.isEmpty else { return [alreadyVisited] }
//
//            return await destinations.concurrentFlatMap { await findAllPathsModified(from: $0, alreadyVisited: alreadyVisited) }
//        }
//
//        let modifiedPaths = await findAllPathsModified(from: .small("start"), alreadyVisited: [:]).filter { $0[.small("end")] != nil }

        func findAllPathsModified(from cave: Cave, alreadyVisited: [Cave: Int], result: inout [[Cave: Int]]) {
            var alreadyVisited = alreadyVisited
            guard cave != .small("end") else { alreadyVisited[cave] = 1; result.append(alreadyVisited); return }

            let destinations = caves[cave, default: []].filter { destination in
                if destination.name == "start" { return false }

                if destination.isLarge { return true }

                if alreadyVisited[destination] == nil { return true }

                let smallCounts = alreadyVisited.count { visitedCave, count in
                    !visitedCave.isLarge && (count == 2 || visitedCave == cave)
                }

                return smallCounts == 0
            }

            alreadyVisited[cave, default: 0] += 1

            guard !destinations.isEmpty else { return result.append(alreadyVisited) }

            destinations.forEach { findAllPathsModified(from: $0, alreadyVisited: alreadyVisited, result: &result) }
        }

        var result: [[Cave: Int]] = []
        findAllPathsModified(from: .small("start"), alreadyVisited: [:], result: &result)

        output.stepTwo = "\(result.filter { $0[.small("end")] != nil }.count)"

//        actor Results {
//            private var storage: [[Cave: Int]] = []
//
//            var pathsToTheEnd: Int {
//                storage.count { $0[.small("end")] != nil }
//            }
//
//            func append(_ value: [Cave: Int]) {
//                storage.append(value)
//            }
//        }
//
//        func findAllPathsModified(from cave: Cave, alreadyVisited: [Cave: Int], result: Results) async {
//            var alreadyVisited = alreadyVisited
//            guard cave != .small("end") else { alreadyVisited[cave] = 1; await result.append(alreadyVisited); return }
//
//            let destinations = caves[cave, default: []].filter { destination in
//                if destination.name == "start" { return false }
//
//                if destination.isLarge { return true }
//
//                if alreadyVisited[destination] == nil { return true }
//
//                let smallCounts = alreadyVisited.count { visitedCave, count in
//                    !visitedCave.isLarge && (count == 2 || visitedCave == cave)
//                }
//
//                return smallCounts == 0
//            }
//
//            alreadyVisited[cave, default: 0] += 1
//
//            guard !destinations.isEmpty else { return await result.append(alreadyVisited) }
//
//            await destinations.concurrentForEach { await findAllPathsModified(from: $0, alreadyVisited: alreadyVisited, result: result) }
//        }
//
//        let result = Results()
//        await findAllPathsModified(from: .small("start"), alreadyVisited: [:], result: result)
//
//        output.stepTwo = await "\(result.pathsToTheEnd)"
        output.expectedStepTwo = "120535"
    }
}

private enum Cave: Hashable {
    case small(String)
    case large(String)

    var name: String {
        switch self {
        case let .large(s), let .small(s): return s
        }
    }

    var isLarge: Bool {
        guard case .large = self else { return false }

        return true
    }

    init(_ string: String) {
        if string.first!.isUppercase {
            self = .large(string)
        } else {
            self = .small(string)
        }
    }
}

extension Cave: CustomStringConvertible {
    var description: String {
        switch self {
        case let .small(s): return ".small(\(s))"
        case let .large(s): return ".large(\(s))"
        }
    }
}

private struct Connection {
    let left: Cave
    let right: Cave

    init(_ strings: [String]) {
        left = Cave(strings[0])
        right = Cave(strings[1])
    }
}

extension Connection: CustomStringConvertible {
    var description: String {
        "\(left) - \(right)"
    }
}
