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
    
    public var keyedRows: [[String: String]]
    
    public init(fromString string: String, withConfiguration configuration: ParserConfiguration) throws {
        self.inputString = string
        self.configuration = configuration
        self.headers = []
        self.rows = []
        self.keyedRows = []
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
        
        var allRows = self.inputString.split(separator: self.configuration.newLineType.rawValue)
        if self.configuration.hasHeaders {
            self.headers = allRows.removeFirst().split(separator: self.configuration.delimiter)
            
        }
        
        if self.configuration.hasHeaders {
            for i in 0 ..< allRows.count {
                let values = allRows[i].split(separator: self.configuration.delimiter)
                guard values.count == self.headers.count else {
                    throw EParseError.InvalidInput(message: "Header count (\(self.headers.count)) does not match value count (\(values.count)) at index [\(i)]")
                }
            }
        }
        
        if let maxLines = self.configuration.maxLines {
            guard maxLines > 0 else {
                throw EParseError.InvalidConfiguration(message: "Max lines must be greater than 0, found '\(maxLines)'")
            }
            
            while allRows.count > 0 && allRows.count > maxLines {
                allRows.removeLast()
            }
        }
        
        self.rows = allRows
        
        self.keyedRows = self.generateKeyedRows()
        
    }
    
    private func generateKeyedRows() -> [[String : String]] {
        var allDicts: [[String: String]] = []
        for row in self.rows {
            var dict = [String : String]()
            let values = row.split(separator: self.configuration.delimiter)
            for i in 0 ..< values.count {
                dict.updateValue(values[i] == "" ? "" : values[i], forKey: self.headers.isEmpty ? String(i) : self.headers[i])
            }
            allDicts.append(dict)
        }
        return allDicts
    }

}
