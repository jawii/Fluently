//
//  TimeInterval+Ext.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 23/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

extension TimeInterval {
    func convertToStringDuration() -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .second]
        formatter.unitsStyle = .short
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        formatter.zeroFormattingBehavior = .default
        
        if let formattedString = formatter.string(from: self) {
            return formattedString
        } else {
            return " "
        }
    }
}
