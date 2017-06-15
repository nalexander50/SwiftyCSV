//
//  ParserConfiguration.swift
//  SwiftyCSV
//
//  Created by Nick Alexander on 6/12/17.
//  Copyright © 2017 com.alexander. All rights reserved.
//

import Foundation
public class ParserConfiguration {
    
    public var hasHeaders: Bool = true
    public var delimiter: Character = ","
    public var newLineType: ENewlineType = .unix
    public var maxLines: Int? = nil
 
    public init() {
        
    }
    
    public convenience init(delimiter: Character, newLineType: ENewlineType, hasHeaders: Bool, maxLines: Int?) {
        self.init()
        self.delimiter = delimiter
        self.newLineType = newLineType
        self.hasHeaders = hasHeaders
        self.maxLines = maxLines
    }
    
}
