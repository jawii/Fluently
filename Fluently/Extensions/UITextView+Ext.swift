//
//  UITextView+Ext.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 09/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

extension UITextView {
    func getWordAtPosition(_ point: CGPoint) -> String?{
        if let textPosition = self.closestPosition(to: point) {
            if let range = self.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: UITextDirection(rawValue: 1)) {
                return self.text(in: range)
            }
        }
        return nil
    }
}

