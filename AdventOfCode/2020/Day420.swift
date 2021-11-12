//
//  Day118.swift
//  AdventOfCode
//
//  Created by Jon Shier on 11/30/18.
//  Copyright © 2018 Jon Shier. All rights reserved.
//

import Foundation
import RegexOld
import Regex
import MatchingEngine

final class Day420: Day {
    override var expectedStageOneOutput: String? { "233" }
    override var expectedStageTwoOutput: String? { "111" }

    override func perform() {
        let input = String.input(forDay: 4, year: 2020)
        let possiblePassports = input.byParagraphs()
        
        struct Passport {
            let birthYear: String
            let issueYear: String
            let expirationYear: String
            let height: String
            let hairColor: String
            let eyeColor: String
            let passportID: String
            let countryID: String?
            
            var isValid: Bool {
                birthYear.count == 4
            }
            
            init?(_ paragraph: String) {
                let partStrings = paragraph.components(separatedBy: .whitespacesAndNewlines)
                let parts: [String: String] = Dictionary(uniqueKeysWithValues: partStrings.map {
                    let components = $0.split(separator: ":").map(String.init)
                    return (components[0], components[1])
                })
                
                guard let birthYear = parts["byr"], let issueYear = parts["iyr"], let expirationYear = parts["eyr"],
                      let height = parts["hgt"], let hairColor = parts["hcl"], let eyeColor = parts["ecl"],
                      let passportID = parts["pid"] else { return nil }
                
                self.birthYear = birthYear
                self.issueYear = issueYear
                self.expirationYear = expirationYear
                self.height = height
                self.hairColor = hairColor
                self.eyeColor = eyeColor
                self.passportID = passportID
                self.countryID = parts["cid"]
            }
        }
        
        let passports = possiblePassports.compactMap(Passport.init)
        
        stageOneOutput = "\(passports.count)"
        
        struct ValidatedPassport {
            enum EyeColor: String {
                case amb, blu, brn, gry, grn, hzl, oth
            }
            let paragraph: String
            let birthYear: Int
            let issueYear: Int
            let expirationYear: Int
            let height: String
            let hairColor: String
            let eyeColor: EyeColor
            let passportID: String
            let countryID: String?
            
            var isValid: Bool {
                (birthYear >= 1920 && birthYear <= 2002) &&
                (issueYear >= 2010 && issueYear <= 2020) &&
                (expirationYear >= 2020 && expirationYear <= 2030) &&
                Regex("^(1[5-8][0-9]|19[0-3])cm|(59|6[0-9]|7[0-6])in$").matches(height) &&
                Regex("^#[0-9a-f]{6}$").matches(hairColor) &&
                passportID.allSatisfy { $0.isWholeNumber && $0.isASCII } && passportID.count == 9
            }
            
            init?(_ paragraph: String) {
                let partStrings = paragraph.components(separatedBy: .whitespacesAndNewlines)
                let parts: [String: String] = Dictionary(uniqueKeysWithValues: partStrings.map {
                    let components = $0.split(separator: ":").map(String.init)
                    return (components[0], components[1])
                })
                
                guard let birthYear = parts["byr"].flatMap(Int.init), let issueYear = parts["iyr"].flatMap(Int.init), let expirationYear = parts["eyr"].flatMap(Int.init),
                      let height = parts["hgt"], let hairColor = parts["hcl"], let eyeColor = parts["ecl"].flatMap(EyeColor.init),
                      let passportID = parts["pid"] else { return nil }
                
                self.paragraph = paragraph
                self.birthYear = birthYear
                self.issueYear = issueYear
                self.expirationYear = expirationYear
                self.height = height
                self.hairColor = hairColor
                self.eyeColor = eyeColor
                self.passportID = passportID
                self.countryID = parts["cid"]
            }
        }
        
        let validPassports = possiblePassports.compactMap(ValidatedPassport.init).filter(\.isValid)
        
        stageTwoOutput = "\(validPassports.count)"
    }
}
