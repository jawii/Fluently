//
//  LanguageService.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 19/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

class LanguageService {
    
    private let LEARNING_LANGUAGE_KEY = "fluently.currentLearningLanguage"
    
    static let shared = LanguageService()
    
    var appLanguage = LearningLanguage.englishUS
    
    
    var learningLanguage: LearningLanguage {
        get {
            var returnValue: LearningLanguage
            if let langRawValue = UserDefaults.standard.string(forKey: LEARNING_LANGUAGE_KEY)  {
                returnValue = LearningLanguage(rawValue: langRawValue)!
            } else {
                returnValue = LearningLanguage.finnish
            }
            return returnValue
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: LEARNING_LANGUAGE_KEY)
        }
    }
    
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
