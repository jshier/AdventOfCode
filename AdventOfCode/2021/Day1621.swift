//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

extension TwentyTwentyOne {
    func daySixteen(input: String, output: inout DayOutput) async {
        let binaryString = input.map { Int(String($0), radix: 16)!.binaryRepresentation(paddedToLength: 4) }.joined()
        let binary = binaryString.map { $0 }

        var reader = 0

        func parsePacket(atReader reader: inout Int) -> Packet {
            let packet: Packet
            let header = Packet.Header(binary[reader..<reader + 6])
            reader += 6
            if header.id == .literal { // literal
                var literalBinary: [Character] = []
                while true {
                    let shouldBreak = binary[reader] == "0"
                    literalBinary.append(contentsOf: binary[(reader + 1)..<(reader + 5)])
                    reader += 5
                    if shouldBreak { break }
                }
                let binaryNumber = Int(literalBinary)

                packet = Packet(header: header, kind: .literal(binaryNumber))
            } else {
                let lengthTypeID = Int(binary[reader])
                reader += 1
                let lengthType: Packet.LengthType
                if lengthTypeID == 0 {
                    let totalLength = Int(binary[reader..<reader + 15])
                    lengthType = .totalLength(bits: totalLength)
                    reader += 15
                    // total length in 15 bits
                } else {
                    let subpackets = Int(binary[reader..<reader + 11])
                    lengthType = .subpackets(count: subpackets)
                    reader += 11
                    // 11 bits of the number of subpackets
                }

                packet = Packet(header: header, kind: .operator(length: lengthType, subpackets: parsePackets(atReader: &reader, ofLength: lengthType)))
            }

            return packet
        }

        func parsePackets(atReader reader: inout Int, ofLength length: Packet.LengthType) -> [Packet] {
            var packets: [Packet] = []
            switch length {
            case let .totalLength(bits):
                let start = reader
                while reader != start + bits {
                    packets.append(parsePacket(atReader: &reader))
                }
            case let .subpackets(count):
                for _ in 0..<count {
                    packets.append(parsePacket(atReader: &reader))
                }
            }

            return packets
        }

        let packet = parsePacket(atReader: &reader)

        output.stepOne = "\(packet.versionValue)"
        output.expectedStepOne = "875"

        output.stepTwo = "\(packet.value)"
    }
}

private struct Packet {
    struct Header {
        enum TypeID: Int {
            case sum, product, minimum, maximum, literal, greaterThan, lessThan, equalTo
        }

        let version: Int
        let id: TypeID

        init<C>(_ characters: C) where C: Collection, C.Element == Character, C.Index == Int {
            version = Int(characters[characters.startIndex..<characters.startIndex + 3])
            id = TypeID(rawValue: Int(characters[(characters.startIndex + 3)...]))!
        }
    }

    enum Kind {
        case literal(Int)
        case `operator`(length: LengthType, subpackets: [Packet])
    }

    enum LengthType {
        case totalLength(bits: Int), subpackets(count: Int)
    }

    let header: Header
    let kind: Kind

    var versionValue: Int {
        switch kind {
        case .literal:
            return header.version
        case let .operator(_, subpackets):
            return header.version + subpackets.map(\.versionValue).sum
        }
    }

    var value: Int {
        switch kind {
        case let .literal(value): return value
        case let .operator(_, subpackets):
            let values = subpackets.map(\.value)
            switch header.id {
            case .sum:
                return values.sum
            case .product:
                return values.product()
            case .minimum:
                return values.min()!
            case .maximum:
                return values.max()!
            case .literal:
                fatalError()
            case .greaterThan:
                assert(subpackets.count == 2)
                return (subpackets[0].value > subpackets[1].value) ? 1 : 0
            case .lessThan:
                assert(subpackets.count == 2)
                return (subpackets[0].value < subpackets[1].value) ? 1 : 0
            case .equalTo:
                assert(subpackets.count == 2)
                return (subpackets[0].value == subpackets[1].value) ? 1 : 0
            }
        }
    }
//    let data: [Character]
}

private extension Int {
    init<C>(_ binaryCharacters: C) where C: Collection, C.Element == Character, C.Index == Int {
        self = Int(String(binaryCharacters), radix: 2)!
    }

    init(_ binaryCharacter: Character) {
        self = Int(String(binaryCharacter), radix: 2)!
    }
}
