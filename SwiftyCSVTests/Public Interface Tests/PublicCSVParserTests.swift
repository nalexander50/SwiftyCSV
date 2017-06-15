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
                        switch error {
                            case EParseError.InvalidInput(let message):
                                expect(message).to(equal("Empty Input"))
                            default:
                                fatalError("Unexpected error: \(error)")
                        }
                    }))
                }
            }
            
            context("with an empty file") {
                it("throws an InvalidInput error") {
                    let file = DataConstants.path(fileInfo: DataConstants.empty)
                    expect { try DelimitedStringParser(contentsOfFile: file!) }.to(throwError(closure: { (error) in
                        switch error {
                            case EParseError.InvalidInput(let message):
                                expect(message).to(equal("Empty Input"))
                            default:
                                fatalError("Unexpected error: \(error)")
                        }
                    }))
                }
            }
            
            context("with the wrong delimiter") {
                it("throws an InvalidInput error") {
                    expect { try DelimitedStringParser(fromString: "1/2/3/4/5") }.to(throwError(closure: { (error) in
                        switch error {
                            case EParseError.InvalidInput(let message):
                                expect(message).to(equal("Input does not contain delimiter ','"))
                            default:
                                fatalError("Unexpected error: \(error)")
                        }
                    }))
                }
            }
            
            context("with an invalid file path") {
                it("throws an InvalidInput error") {
                    expect { try DelimitedStringParser(contentsOfFile: "/BadFile") }.to(throwError(closure: { (error) in
                        switch error {
                            case EParseError.InvalidInput(let message):
                                expect(message).to(equal("Could not load file at '/BadFile'"))
                            default:
                                fatalError("Unexpected error: \(error)")
                        }
                    }))
                }
            }
            
            context("with fewer headers than values per row") {
                it("throws an InvalidInput error") {
                    let file = DataConstants.path(fileInfo: DataConstants.tooFewHeaders)
                    expect { try DelimitedStringParser(contentsOfFile: file!) }.to(throwError(closure: { (error) in
                        switch error {
                            case EParseError.InvalidInput(let message):
                                expect(message).to(equal("Header count (5) does not match value count (6) at index [0]"))
                            default:
                                fatalError("Unexpected error: \(error)")
                        }
                    }))
                }
            }
            
            context("with fewer values than headers per row") {
                it("throws an InvalidInput error") {
                    let file = DataConstants.path(fileInfo: DataConstants.tooFewValues)
                    expect { try DelimitedStringParser(contentsOfFile: file!) }.to(throwError(closure: { (error) in
                        switch error {
                            case EParseError.InvalidInput(let message):
                                expect(message).to(equal("Header count (6) does not match value count (5) at index [2]"))
                            default:
                                fatalError("Unexpected error: \(error)")
                        }
                    }))
                }
            }
            
            context("with an invalid max line count") {
                it("throws an InvalidConfiguration error") {
                    let config = ParserConfiguration(delimiter: ",", newLineType: .unix, hasHeaders: true, maxLines: -1)
                    expect { try DelimitedStringParser(fromString: "1,2,3,4,5", withConfiguration: config) }.to(throwError(closure: { (error) in
                        switch error {
                            case EParseError.InvalidConfiguration(let message):
                                expect(message).to(equal("Max lines must be greater than 0, found '-1'"))
                            default:
                                fatalError("Unexpected error: \(error)")
                        }
                    }))
                }
            }
            
            context("with a 1,000 row UNIX CSV with header row") {
                it("parses the file and extracts all rows and the headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnixHeaders)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!)
                    expect(parser.headers).to(equal(["id", "first_name", "last_name", "email", "gender", "ip_address"]))
                    expect(parser.rows.count).to(equal(1000))
                }
            }
            
            context("with a UNIX CSV with 1,000 rows without headers") {
                it("parses the file and extracts all 1,000 rows and no headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnix)
                    let config = ParserConfiguration(delimiter: ",", newLineType: .unix, hasHeaders: false, maxLines: nil)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).to(beEmpty())
                    expect(parser.rows.count).to(equal(1000))
                }
            }
            
            context("with a Windows CSV with 1,000 rows and headers") {
                it("parses the file and extracts all rows and the headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvWindowsHeader)
                    let config = ParserConfiguration(delimiter: ",", newLineType: .windows, hasHeaders: true, maxLines: nil)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).to(equal(["id", "first_name", "last_name", "email", "gender", "ip_address"]))
                    expect(parser.rows.count).to(equal(1000))
                }
            }
            
            context("with a Windows CSV with 1,000 rows without headers") {
                it("parses the file and extracts all 1,000 rows and no headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvWindows)
                    let config = ParserConfiguration(delimiter: ",", newLineType: .windows, hasHeaders: false, maxLines: nil)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).to(beEmpty())
                    expect(parser.rows.count).to(equal(1000))
                }
            }
            
            context("with Windows TSV with 1,000 rows and no headers") {
                it("parses the file and extracts all 1,000 rows without headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.tsvWindows)
                    let config = ParserConfiguration(delimiter: "\t", newLineType: .windows, hasHeaders: false, maxLines: nil)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).to(beEmpty())
                    expect(parser.rows.count).to(equal(1000))
                }
            }
            
            context("with max lines of 300 with headers") {
                it("parses the file and extracts up to 300 lines and the headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnixHeaders)
                    let config = ParserConfiguration(delimiter: ",", newLineType: .unix, hasHeaders: true, maxLines: 300)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers.count).to(equal(6))
                    expect(parser.rows.count).to(equal(300))
                }
            }
            
            context("with max lines of 300 wihtout headers") {
                it("parses the file and extracts up to 300 lines and no headers") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnixHeaders)
                    let config = ParserConfiguration(delimiter: ",", newLineType: .unix, hasHeaders: false, maxLines: 300)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    expect(parser.headers).to(beEmpty())
                    expect(parser.rows.count).to(equal(300))
                }
            }
            
            context("with 1,000 row UNIX CSV with headers") {
                it("parses all 1,000 rows and headers and generates keyed rows") {
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnixHeaders)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!)
                    let keyedRow: [String : String] = [
                        "id" : "1",
                        "first_name" : "Karlan",
                        "last_name" : "Snibson",
                        "email" : "ksnibson0@imgur.com",
                        "gender" : "",
                        "ip_address" : "240.47.251.161"
                    ]
                    
                    expect(parser.headers).to(equal(["id", "first_name", "last_name", "email", "gender", "ip_address"]))
                    expect(parser.rows.count).to(equal(1000))
                    expect(parser.keyedRows.count).to(equal(1000))
                    expect(parser.keyedRows.first!).to(equal(keyedRow))
                }
            }
            
            context("with 1,000 row UNIX CSV without headers") {
                it("parses all 1,000 rows and generates keyed rows") {
                    let config = ParserConfiguration(delimiter: ",", newLineType: .unix, hasHeaders: false, maxLines: nil)
                    let file = DataConstants.path(fileInfo: DataConstants.csvUnix)
                    let parser = try! DelimitedStringParser(contentsOfFile: file!, withConfiguration: config)
                    let keyedRow: [String : String] = [
                        "0" : "1",
                        "1" : "Karlan",
                        "2" : "Snibson",
                        "3" : "ksnibson0@imgur.com",
                        "4" : "",
                        "5" : "240.47.251.161"
                    ]
                    
                    expect(parser.headers.count).to(equal(0))
                    expect(parser.rows.count).to(equal(1000))
                    expect(parser.keyedRows.count).to(equal(1000))
                    expect(parser.keyedRows.first!).to(equal(keyedRow))
                }
            }
            
            context("with 25,000 line CSV with headers") {
                it("parses 25,000 rows and headers in under 2 seconds") {
                    let file = DataConstants.path(fileInfo: DataConstants.extremeUnix)
                    let startTime = DispatchTime.now()
                    let parser = try! DelimitedStringParser(contentsOfFile: file!)
                    let endTime = DispatchTime.now()
                    let elapsedSeconds = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
                    expect(parser.headers.count).to(equal(6))
                    expect(parser.rows.count).to(equal(25_000))
                    expect(elapsedSeconds).to(beLessThan(5))
                }
            }
            
        }
    }
    
}
