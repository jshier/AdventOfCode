//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

final class Day1720: Day {
    override var expectedStageOneOutput: String? { nil }
    override var expectedStageTwoOutput: String? { nil }

    override func perform() async {
        // let input = String.input(forDay: 17, year: 2020)
        let input = """
        .#.
        ..#
        ###
        """

        enum Cube: String, SparselyRepresentable, CustomStringConvertible {
            static let sparseValue: Cube = .inactive

            case active = "#"
            case inactive = "."

            var description: String {
                rawValue
            }
        }

        let pointCubes: [(Point3D, Cube)] = input.byLines().indexed().flatMap { y, line in
            line.map(String.init).indexed().map { x, character in
                (Point3D(x: x, y: y, z: 0), Cube(rawValue: character)!)
            }
        }

        var cubes = SparseSpace(initialValues: Dictionary(uniqueKeysWithValues: pointCubes))

        debugPrint(cubes)
    }
}

struct Point3D {
    var x: Int
    var y: Int
    var z: Int

    var surroundingPoints: [Point3D] {
        var points: [Point3D] = []
        for newX in (x - 1)...(x + 1) {
            for newY in (y - 1)...(y + 1) {
                for newZ in (z - 1)...(z + 1) {
                    if newX == x && newY == y && newZ == z { continue }

                    points.append(Point3D(x: newX, y: newY, z: newZ))
                }
            }
        }

        return points
    }
}

extension Point3D: Equatable, Hashable {}
extension Point3D: Comparable {
    static func < (lhs: Point3D, rhs: Point3D) -> Bool {
        if lhs.x != rhs.x {
            return lhs.x < rhs.x
        }

        if lhs.y != rhs.y {
            return lhs.y < rhs.y
        }

        return lhs.z < rhs.z
    }
}

struct SparseSpace<T: SparselyRepresentable> {
    private var space: [Point3D: T] = [:]

    subscript(_ point: Point3D) -> T? {
        get { space[point, default: T.sparseValue] }
        set {
            if let newValue = newValue {
                space[point] = newValue
            } else {
                space.removeValue(forKey: point)
            }
        }
    }

    subscript(x: Int, y: Int, z: Int) -> T? {
        self[Point3D(x: x, y: y, z: z)]
    }
}

extension SparseSpace {
    init(initialValues: [Point3D: T]) {
        space = initialValues
    }
}

protocol SparselyRepresentable {
    static var sparseValue: Self { get }
}

extension SparseSpace: CustomDebugStringConvertible {
    var debugDescription: String {
        let keys = space.keys

        guard !keys.isEmpty else { return "No values." }

        return keys
            .sorted { $0.z > $1.z }
            .chunked { $0.z == $1.z }
            .map { zChunk -> String in
                """
                z = \(zChunk.first!.z)
                \(zChunk.sorted { $0.y < $1.y }
                    .chunked { $0.y == $1.y }
                    .map { $0.sorted()
                        .map { String(describing: self[$0] ?? T.sparseValue) }
                        .joined()
                    }
                    .joined(separator: "\n"))
                """
            }
            .joined(separator: "\n\n")
    }
}
