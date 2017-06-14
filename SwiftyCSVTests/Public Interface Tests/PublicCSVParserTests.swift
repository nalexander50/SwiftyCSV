//
//  PublicCSVParserTests.swift
//  SwiftyCSVTests
//
//  Created by Nick Alexander on 6/11/17.
//  Copyright © 2017 com.alexander. All rights reserved.
//

import Quick
import Nimble
import SwiftyCSV

class PublicCSVParserTests: QuickSpec {
    
    override func spec() {
        describe("Init CSVParser") {
            
            context("with an empty string") {
                it("throws an InvalidInput error") {
                    expect { try DelimitedStringParser(fromString: "") }.to(throwError(closure: { (error) in
                        expect(error).to(beAKindOf(EParseError.self))
                        switch error {
                        case EParseError.InvalidInput(let message):
                            expect(message).to(equal("Empty Input"))
                        default:
                            expect(false).to(beTrue())
                        }
                    }))
                }
            }
            
            context("with the wrong delimiter") {
                it("throws an InvalidInput error") {
                    expect { try DelimitedStringParser(fromString: "1/2/3/4/5") }.to(throwError(closure: { (error) in
                        expect(error).to(beAKindOf(EParseError.self))
                        switch error {
                        case EParseError.InvalidInput(let message):
                            expect(message).to(equal("Input does not contain delimiter ','"))
                        default:
                            expect(false).to(beTrue())
                        }
                    }))
                }
            }
            
            context("with an invalid file path") {
                it("throws an InvalidInput error") {
                    expect { try DelimitedStringParser(contentsOfFile: "/BadFile") }.to(throwError(closure: { (error) in
                        expect(error).to(beAKindOf(EParseError.self))
                        switch error {
                            case EParseError.InvalidInput(let message):
                                expect(message).to(equal("Could not load file at '/BadFile'"))
                            default:
                                expect(false).to(beTrue())
                        }
                    }))
                }
            }
            
            context("with a UNIX CSV with header row") {
                it("parses the file and extracts the headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnixHeaders)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!)
                    expect(parser.headers).toNot(beEmpty())
                    expect(parser.headers).to(equal(["id", "first_name", "last_name", "email", "gender", "ip_address"]))
                }
            }
            
            context("with a UNIX CSV with 1,000 rows") {
                it("parses the file and extracts all 1,000 rows") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnixHeaders)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!)
                    expect(parser.rows.count).to(equal(1000))
                }
            }
            
            context("with a Windows CSV with header row") {
                it("parses the file and extracts the headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvWindowsHeader)
                    let config = ParserConfiguration()
                    config.newLineCharacter = .windows
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).toNot(beEmpty())
                    expect(parser.headers).to(equal(["id", "first_name", "last_name", "email", "gender", "ip_address"]))
                }
            }
            
            context("with a Windows CSV with 1,000 rows") {
                it("parses the file and extracts all 1,000 rows") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvWindowsHeader)
                    let config = ParserConfiguration()
                    config.newLineCharacter = .windows
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.rows.count).to(equal(1000))
                }
            }
            
            context("with Windows TSV with 1,000 rows and no headers") {
                it("parses the file and extracts all 1,000 rows without headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.tsvWindows)
                    let config = ParserConfiguration()
                    config.delimiter = "\t"
                    config.hasHeaders = false
                    config.newLineCharacter = .windows
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).to(beEmpty())
                    expect(parser.rows.count).to(equal(1000))
                }
            }
            
            context("with max lines of 300 plus headers") {
                it("parses the file and extracts up to 300 lines plus the headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnixHeaders)
                    let config = ParserConfiguration()
                    config.maxLines = 300
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).toNot(beEmpty())
                    expect(parser.rows.count).to(equal(300))
                }
            }
            
            context("with max lines of 300 wihtout headers") {
                it("parses the file and extracts up to 300 lines without the headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnixHeaders)
                    let config = ParserConfiguration()
                    config.maxLines = 300
                    config.hasHeaders = false
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).to(beEmpty())
                    expect(parser.rows.count).to(equal(300))
                }
            }
            
            context("with 25,000 line CSV") {
                it("parses in under 3 seconds") {
                    let file = DataConstants.path(fileInfo: DataConstants.extremeUnix)
                    let config = ParserConfiguration()
                    config.hasHeaders = false
                    let startTime = DispatchTime.now()
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    let endTime = DispatchTime.now()
                    let elapsedSeconds = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
                    expect(parser.rows.count).to(equal(25_000))
                    expect(elapsedSeconds).to(beLessThan(3.0))
                }
            }
            
        }
    }
    
}
