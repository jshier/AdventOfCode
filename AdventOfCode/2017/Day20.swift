//
//  Day20.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/26/17.
//  Copyright © 2017 Jon Shier. All rights reserved.
//

import Foundation

final class Day20: Day {
    override func perform() {
        let fileInput = String.input(forDay: 20, year: 2017)
//        let testInput = """
//                        p=<-6,0,0>, v=<3,0,0>, a=<0,0,0>
//                        p=<-4,0,0>, v=<2,0,0>, a=<0,0,0>
//                        p=<-2,0,0>, v=<1,0,0>, a=<0,0,0>
//                        p=<3,0,0>, v=<-1,0,0>, a=<0,0,0>
//                        """
        let input = fileInput
        let lines = input.split(separator: "\n")
        let startingParticles = lines.map(Particle.init)
        var particles = startingParticles
        for _ in 0..<1000 {
            for i in 0..<particles.count {
                particles[i] = particles[i].move()
            }
        }
        let distances = particles.map { $0.position.distanceToOrigin }
        let minIndex = distances.firstIndex(of: distances.min()!)!
        stageOneOutput = "\(minIndex)"

        var collisionParticles = startingParticles
        for _ in 0..<1000 {
            var newParticles: [Particle] = []
            for particle in collisionParticles {
                newParticles.append(particle.move())
            }
            var positionsSeen: Set<Vector> = []
            var positionsRemoved: Set<Vector> = []
            var index = newParticles.startIndex
            while index < newParticles.endIndex {
                if positionsSeen.contains(newParticles[index].position) {
                    positionsRemoved.insert(newParticles[index].position)
                    newParticles.remove(at: index)
                } else {
                    positionsSeen.insert(newParticles[index].position)
                    index = newParticles.index(after: index)
                }
            }

            index = newParticles.startIndex
            while index < newParticles.endIndex {
                if positionsRemoved.contains(newParticles[index].position) {
                    newParticles.remove(at: index)
                } else {
                    index = newParticles.index(after: index)
                }
            }
            collisionParticles = newParticles
        }

        stageTwoOutput = "\(collisionParticles.count)"
    }
}

struct Particle: Hashable {
    let position: Vector
    let velocity: Vector
    let acceleration: Vector

    init(_ position: Vector, _ velocity: Vector, _ acceleration: Vector) {
        self.position = position
        self.velocity = velocity
        self.acceleration = acceleration
    }

    init(_ line: Substring) {
        let components = line.components(separatedBy: ", ").map { $0.dropFirst(3).dropLast() }.map(Vector.init)
        position = components[0]
        velocity = components[1]
        acceleration = components[2]
    }

    func move() -> Particle {
        let newVelocity = velocity + acceleration
        let newPosition = position + newVelocity

        return Particle(newPosition, newVelocity, acceleration)
    }
}

extension Particle: CustomStringConvertible {
    var description: String {
        "p=\(position), v=\(velocity), a=\(acceleration)"
    }
}

struct Vector: Hashable {
    let x: Int
    let y: Int
    let z: Int

    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    init(_ string: Substring) {
        let components = string.split(separator: ",").compactMap { Int($0) }
        x = components[0]
        y = components[1]
        z = components[2]
    }
}

extension Vector {
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        let x = lhs.x + rhs.x
        let y = lhs.y + rhs.y
        let z = lhs.z + rhs.z

        return Vector(x, y, z)
    }

    var distanceToOrigin: Int {
        abs(x) + abs(y) + abs(z)
    }
}

extension Vector: CustomStringConvertible {
    var description: String {
        "<\(x),\(y),\(z)>"
    }
}
