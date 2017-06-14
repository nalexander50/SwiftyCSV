//
//  DelimitedStringParser.swift
//  SwiftyCSV
//
//  Created by Nick Alexander on 6/11/17.
//  Copyright © 2017 com.alexander. All rights reserved.
//

public class DelimitedStringParser {
    
    var inputString: String
    var configuration: ParserConfiguration
    
    public var headers: [String]
    public var rows: [String]
    
    public var keyedRows: [String: String] {
        get {
            return [:]
        }
    }
    
    public init(fromString string: String, withConfiguration configuration: ParserConfiguration) throws {
        self.inputString = string
        self.configuration = configuration
        self.headers = []
        self.rows = []
        try self.parse()
    }
    
    public convenience init(fromString string: String) throws {
        try self.init(fromString: string, withConfiguration: ParserConfiguration())
    }
    
    public convenience init(contentsOfFile filePath: String, withConfiguration configuration: ParserConfiguration) throws {
        do {
            try self.init(fromString: try String(contentsOfFile: filePath), withConfiguration: configuration)
        } catch EParseError.InvalidInput(let message) {
            throw EParseError.InvalidInput(message: message)
        } catch {
            throw EParseError.InvalidInput(message: "Could not load file at '\(filePath)'")
        }
    }
    
    public convenience init(contentsOfFile filePath: String) throws {
        try self.init(contentsOfFile: filePath, withConfiguration: ParserConfiguration())
    }
    
    private func parse() throws {
        guard !self.inputString.isEmpty else {
            throw EParseError.InvalidInput(message: "Empty Input")
        }
        
        guard self.inputString.characters.contains(self.configuration.delimiter) else {
            throw EParseError.InvalidInput(message: "Input does not contain delimiter '\(self.configuration.delimiter)'")
        }
        
        var allRows = self.inputString.split(separator: self.configuration.newLineCharacter.rawValue)
        if self.configuration.hasHeaders {
            self.headers = allRows.removeFirst().split(separator: self.configuration.delimiter)
        }
        
        if self.configuration.maxLines > 0 {
            while allRows.count > 0 && allRows.count > self.configuration.maxLines {
                allRows.removeLast()
            }
        }
        
        self.rows = allRows
        
    }

}
