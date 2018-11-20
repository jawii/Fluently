//
//  LanguageService.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 19/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

enum LearningLanguage: String, CaseIterable {
    case finnish = "fi_FI"
    case englishUK = "en_UK"
    case englishUS = "en_US"
    case swedish = "sv_SE"
    case german = "de"
}

class LanguageService {
    
    static let shared = LanguageService()
    
    var appLanguage = LearningLanguage.englishUK
    var learningLanguage = LearningLanguage.englishUK
}