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
    
    var appLanguage = LearningLanguage.finnish
    var learningLanguage = LearningLanguage.englishUK
}
