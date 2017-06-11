//
//  SwiftyCSVTests.swift
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
        describe("CSVParser") {
            it("parses a comma seprated value input") {
                let parser = CSVParser(fromString: "1,2,3,4,5")
                expect(parser).notTo(beNil())
            }
        }
    }
    
}
