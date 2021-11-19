//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day1219: Day {
    override var expectedStageOneOutput: String? { "6220" }
    override var expectedStageTwoOutput: String? { "548525804273976" }

    override func perform() async {
        let input = String.input(forDay: 12, year: 2019)
//        let input = """
//        <x=-1, y=0, z=2>
//        <x=2, y=-10, z=-7>
//        <x=4, y=-8, z=8>
//        <x=3, y=5, z=-1>
//        """
        var moons: [Moon] = input.byLines().map { line in
            let x = Int(line.drop { $0 != "=" }.dropFirst().prefix { $0 != "," })!
            let y = Int(line.drop { $0 != "y" }.dropFirst(2).prefix { $0 != "," })!
            let z = Int(line.drop { $0 != "z" }.dropFirst(2).prefix { $0 != ">" })!
            return Moon(x: x, y: y, z: z)
        }

        var seenX: (Set<Int>, Bool) = ([], false)
        var seenY: (Set<Int>, Bool) = ([], false)
        var seenZ: (Set<Int>, Bool) = ([], false)
        var duplicateDetected = false
        let steps = 1000
        for _ in 0..<steps {
            duplicateDetected = simulateStep(for: &moons, seenX: &seenX, seenY: &seenY, seenZ: &seenZ)
        }

        let totalEnergy = moons.map(\.totalEnergy).reduce(0, +)

        stageOneOutput = "\(totalEnergy)"

        while !duplicateDetected {
            duplicateDetected = simulateStep(for: &moons, seenX: &seenX, seenY: &seenY, seenZ: &seenZ)
        }

        let x = seenX.0.count
        let y = seenY.0.count
        let z = seenZ.0.count

        let overall = x.lowestCommonMultiple(with: y).lowestCommonMultiple(with: z)

        stageTwoOutput = "\(overall)"
    }

    func simulateStep(for moons: inout [Moon], seenX: inout (Set<Int>, Bool), seenY: inout (Set<Int>, Bool), seenZ: inout (Set<Int>, Bool)) -> Bool {
        for pair in [[moons[0], moons[1]], [moons[0], moons[2]], [moons[0], moons[3]], [moons[1], moons[2]], [moons[1], moons[3]], [moons[2], moons[3]]] {
            for axis in Vector3D.axes {
                if pair[0].position[keyPath: axis] > pair[1].position[keyPath: axis] {
                    pair[0].velocity[keyPath: axis] -= 1
                    pair[1].velocity[keyPath: axis] += 1
                } else if pair[0].position[keyPath: axis] < pair[1].position[keyPath: axis] {
                    pair[0].velocity[keyPath: axis] += 1
                    pair[1].velocity[keyPath: axis] -= 1
                }
            }
        }

        moons.forEach { $0.applyVelocity() }

        if !seenX.1 {
            let xs = moons.flatMap { [$0.position.x, $0.velocity.x] }.hashValue
            if seenX.0.contains(xs) {
                seenX.1 = true
            } else {
                seenX.0.insert(xs)
            }
        }

        if !seenY.1 {
            let ys = moons.flatMap { [$0.position.y, $0.velocity.y] }.hashValue
            if seenY.0.contains(ys) {
                seenY.1 = true
            } else {
                seenY.0.insert(ys)
            }
        }

        if !seenZ.1 {
            let zs = moons.flatMap { [$0.position.z, $0.velocity.z] }.hashValue
            if seenZ.0.contains(zs) {
                seenZ.1 = true
            } else {
                seenZ.0.insert(zs)
            }
        }

        return seenX.1 && seenY.1 && seenZ.1
//            print("Step: \(step)")
//            print(moons.map { "pos=<x=\($0.position.x), y=\($0.position.y), z=\($0.position.z)>, vel=<x=\($0.velocity.x), y=\($0.velocity.y), z=\($0.velocity.z)>" }.joined(separator: "\n"))
    }

    final class Moon {
        var position: Vector3D
        var velocity = Vector3D(x: 0, y: 0, z: 0)

        init(x: Int, y: Int, z: Int) {
            position = Vector3D(x: x, y: y, z: z)
        }

        func applyVelocity() {
            position += velocity
        }

        var totalEnergy: Int {
            potentialEnergy * kineticEnergy
        }

        var potentialEnergy: Int {
            abs(position.x) + abs(position.y) + abs(position.z)
        }

        var kineticEnergy: Int {
            abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
        }
    }
}

struct Vector3D: Hashable {
    static let axes: [WritableKeyPath<Vector3D, Int>] = [\.x, \.y, \.z]

    var x: Int
    var y: Int
    var z: Int
}

func + (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
    let x = lhs.x + rhs.x
    let y = lhs.y + rhs.y
    let z = lhs.z + rhs.z

    return Vector3D(x: x, y: y, z: z)
}

func += (lhs: inout Vector3D, rhs: Vector3D) {
    lhs = lhs + rhs
}

func max<T, Path: Comparable>(_ first: T, _ second: T, by keyPath: KeyPath<T, Path>) -> T {
    first[keyPath: keyPath] >= second[keyPath: keyPath] ? first : second
}
