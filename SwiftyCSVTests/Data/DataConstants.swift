//
//  DataConstants.swift
//  SwiftyCSV
//
//  Created by Nick Alexander on 6/12/17.
//  Copyright © 2017 com.alexander. All rights reserved.
//

import Foundation
class DataConstants: NSObject {
    
    static let csvWindows:          (name: String, ext: String) = ("Comma Delimited CRLF", "csv")
    static let csvWindowsHeader:    (name: String, ext: String) = ("Comma Delimited CRLF Header", "csv")
    
    static let csvUnix:             (name: String, ext: String) = ("Comma Delimited LF", "csv")
    static let csvUnixHeaders:      (name: String, ext: String) = ("Comma Delimited LF Header", "csv")
    
    static let tsvWindows:          (name: String, ext: String) = ("Tab Delimited CRLF", "txt")
    static let tsvWindowsHeaders:   (name: String, ext: String) = ("Tab Delimited CRLF Header", "txt")
    
    static let tsvUnix:             (name: String, ext: String) = ("Tab Delimited LF", "txt")
    static let tsvUnixHeaders:      (name: String, ext: String) = ("Tab Delimited LF Header", "txt")
    
    static let extremeUnix:         (name: String, ext: String) = ("Extreme Data", "csv")
    
    static let empty:               (name: String, ext: String) = ("Empty", "csv")
    static let tooFewHeaders:       (name: String, ext: String) = ("Too Few Headers", "csv")
    static let tooFewValues:        (name: String, ext: String) = ("Too Few Values", "csv")
    
    static func path(fileInfo: (name: String, ext: String)) -> String? {
        return Bundle(for: DataConstants.self).path(forResource: fileInfo.name, ofType: fileInfo.ext)
    }
    
}
