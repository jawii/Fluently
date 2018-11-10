//
//  String+Ext.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 09/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

extension String {
    
    func getRanges(of string: String) -> [NSRange] {
        var ranges:[NSRange] = []
        if self.lowercased().contains(string.lowercased()) {
            let words = self.components(separatedBy: " ")
            var position:Int = 0
            for word in words {
                if word.lowercased().contains(string.lowercased()) {
                    let startIndex = position
                    let endIndex = word.count
                    let range = NSMakeRange(startIndex, endIndex)
                    ranges.append(range)
                }
                position += (word.count + 1) // +1 for space
            }
        }
        return ranges
    }
    func highlight(_ words: [String], this color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for word in words {
            let ranges = getRanges(of: word)
            for range in ranges {
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
            }
        }
        return attributedString
    }
    
    var stripped: String {
        return self.filter {GlobalConstants.ALLOWED_CHARACTERS.contains($0) }
    }

}
