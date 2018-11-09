//
//  NSMutString+Ext.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 09/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    func highlight(_ words: [String], this color: UIColor) -> NSMutableAttributedString {
        let attributedString = self
        for word in words {
            let ranges = self.string.getRanges(of: word)
            for range in ranges {
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
            }
        }
        return attributedString
    }
}
