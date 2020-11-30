//
//  Day918.swift
//  AdventOfCode
//
//  Created by Jon Shier on 12/8/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation

final class Day918: Day {
    override func perform() {
        let input = String.input(forDay: 9, year: 2018).byLines()[0]
//        let input = "13 players; last marble is worth 7999 points"
        let game = MarbleGame(input)
        let highPlayerScore = game.play()
        stageOneOutput = "\(highPlayerScore.score)"

        let biggerGame = MarbleGame(players: game.players, finalMarbleValue: game.finalMarbleValue * 100)
        let biggerHigherPlayerScore = biggerGame.play()
        stageTwoOutput = "\(biggerHigherPlayerScore.score)"
    }

    final class MarbleGame {
        final class Marble {
            let number: Int
            var previous: Marble?
            var next: Marble?

            init(number: Int, previous: Marble?, next: Marble?) {
                self.number = number

                self.previous = previous
                self.next = next
            }

            func insertAfter(value: Int) -> Marble {
                let newMarble = Marble(number: value, previous: self, next: next)
                next?.previous = newMarble
                next = newMarble

                return newMarble
            }

            func remove() -> Marble {
                previous?.next = next
                next?.previous = previous

                return self
            }
        }

        let players: Int
        let finalMarbleValue: Int

        var scores: [Int: Int] = [:] // player number: score

        init(_ string: String) {
            players = Int(string.prefix { $0 != " " })!
            finalMarbleValue = Int(String(string.dropLast(7).reversed().prefix { $0 != " " }.reversed()))!
        }

        init(players: Int, finalMarbleValue: Int) {
            self.players = players
            self.finalMarbleValue = finalMarbleValue
        }

        func play() -> (player: Int, score: Int) {
            var current = Marble(number: 0, previous: nil, next: nil)
            current.next = current
            current.previous = current

            let turns = Array(1...players)

            for (player, marble) in zip(turns.cycled(), 1...finalMarbleValue).lazy {
                if marble % 23 == 0 {
                    scores[player] = scores[player, default: 0] + marble
                    let removed = (current.previous?.previous?.previous?.previous?.previous?.previous?.previous?.remove())!
                    scores[player] = scores[player, default: 0] + removed.number
                    current = removed.next!
                } else {
                    current = current.next!.insertAfter(value: marble)
                }

//                if marble % 100_000 == 0 { print("\(marble)") }
            }
            let maxPlayerScore = scores.max { $0.1 < $1.1 }!

            return (player: maxPlayerScore.key, score: maxPlayerScore.value)
        }
    }
}
