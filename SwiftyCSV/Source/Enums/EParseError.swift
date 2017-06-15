//
//  EParseError.swift
//  SwiftyCSV
//
//  Created by Nick Alexander on 6/11/17.
//  Copyright © 2017 com.alexander. All rights reserved.
//

import Foundation

public enum EParseError: Error {
    case InvalidInput(message: String)
    case InvalidConfiguration(message: String)
}
