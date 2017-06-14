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
    public var newLineCharacter: ENewlineType = .unix
    public var maxLines: Int = 0
 
    public init() {
        
    }
    
}
