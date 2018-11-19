//
//  SentenceService.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 18/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

#warning("Test that all locales exists")
enum LearningLanguage: String {
    case finnish = "fi_FI"
    case englishUK = "en_UK"
    case englishUS = "en_US"
    case swedish = "sv_SE"
    case german = "de"
}

enum SentenceCategory: String {
    case smallTalk = "smallTalk"
    case jobInterview = "jobInterview"
    case restaurant
    case travelling
}

class SentenceService {
    
    /// Fetches all sentences for given language and category
    func fetchSententces(forLanguage language: LearningLanguage, andForCategory category: SentenceCategory) -> [Sentence ]{
        
        var sentences = [Sentence]()
        
        if let path = Bundle.main.path(forResource: "sentences", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>,
                let sentenceDic = jsonResult[category.rawValue] as? [[String: String]] {
                    
                    for dic in sentenceDic {
                        let currentLocale = Locale.current.identifier
                        let translated = dic[currentLocale]
                        let saying = dic[language.rawValue]
                        
                        if let translated = translated, let saying = saying {
                            let sentence = Sentence(saying: saying, translation: translated)
                            sentences.append(sentence)
                        }
                    }
                }
            } catch {
                debugPrint(error)
            }
        }
        return sentences
    }
}
