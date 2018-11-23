//
//  LanguageService.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 19/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

class LanguageService {
    
    static let shared = LanguageService()
    
    var appLanguage = LearningLanguage.englishUS
    var learningLanguage = LearningLanguage.finnish
    
    func getNameForLanguage(_ lang: LearningLanguage) -> String {
        switch lang {
        case .englishUK:
            return NSLocalizedString("English(UK)", comment: "Language name")
        case .englishUS:
            return NSLocalizedString("English(US)", comment: "Language name")
        case .finnish:
            return NSLocalizedString("Finnish", comment: "Language name")
        }
    }
}
