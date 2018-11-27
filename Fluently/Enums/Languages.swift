//
//  Languages.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 22/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

enum LearningLanguage: String, CaseIterable, Codable {
    case finnish = "fi_FI"
    case englishUK = "en_UK"
    case englishUS = "en_US"
//    case swedish = "sv_SE"
//    case german = "de"
}


extension LearningLanguage {
    func getFlagImage() -> UIImage {
        var image: UIImage
        switch self {
        case .finnish:
            image = #imageLiteral(resourceName: "fi_FI")
        case .englishUK:
            image = #imageLiteral(resourceName: "en_UK")
        case .englishUS:
            image = #imageLiteral(resourceName: "en_US")
        }
        
        return image
    }
    
    func getLanguageName() -> String {
        var returnString: String
        switch self {
        case .finnish:
            returnString = NSLocalizedString("Finnish", comment: "")
        case .englishUK:
            returnString = NSLocalizedString("English(UK)", comment: "")
        case .englishUS:
            returnString = NSLocalizedString("English(US)", comment: "")
        }
        return returnString
    }
}
