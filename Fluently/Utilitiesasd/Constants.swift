//
//  Constants.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 08/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

enum FONTAvenirNextFamily: String {
    case Regular = "AvenirNext-Regular"
    
    func font (size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
    
    func CTFont (size: CGFloat) -> CTFont {
        return CTFontCreateWithName(self.rawValue as CFString, size, nil)
    }
}

struct GlobalConstants {
    
    
    
    struct Color {
        static let havelockBlue = UIColor(named: "Havelock Blue")!
        static let coral = UIColor(named: "Coral")!
    }
    
    static let ALLOWED_CHARACTERS = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
}
