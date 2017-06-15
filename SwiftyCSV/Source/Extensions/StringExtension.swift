//
//  StringExtension.swift
//  SwiftyCSV
//
//  Created by Nick Alexander on 6/11/17.
//  Copyright © 2017 com.alexander. All rights reserved.
//

import Foundation
extension String {
    
    static func isNilOrEmpty(string: String?) -> Bool {
        return string == nil || string!.isEmpty
    }
    
    func split(separator: Character) -> [String] {
        return self.characters.split(separator: separator, maxSplits: Int.max, omittingEmptySubsequences: false).map(String.init)
    }
    
}
