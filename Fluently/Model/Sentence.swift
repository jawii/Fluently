//
//  Sentence.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 11/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

protocol SentenceDelegate: class {
    func setText(_ text: NSMutableAttributedString)
    func setContextualStrings(to :[String])
    func textSayingComplete()
}

class Sentence {
    let translation: String?
    
    let initialSentence: String
    var sentenceAttrString: NSMutableAttributedString {
        didSet {
            delegate?.setText(sentenceAttrString)
        }
    }
    var words: [String]
    
    weak var delegate: SentenceDelegate?

    
    init(saying: String, translation: String?) {
        self.initialSentence = saying
        
        // Removes all special characters from word and puts them on the list
        self.words = saying.components(separatedBy: " ").map { $0.lowercased().stripped }
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes : [NSAttributedString.Key : Any ] = [
            NSAttributedString.Key.font : UIFont(name: "AvenirNext-Demibold", size: 32)!,
            NSAttributedString.Key.paragraphStyle : style
        ]
        self.sentenceAttrString = NSMutableAttributedString(string: initialSentence, attributes: attributes)
        
        self.translation = translation
    }
    func start() {
        delegate?.setText(sentenceAttrString)
    }
    
    func said(word: String) {
        if words.contains(word.lowercased())
            || initialSentence.lowercased().contains(word.lowercased()){
            sentenceAttrString = sentenceAttrString.highlight([word], this: UIColor.green)
            words = words.filter { $0 != word.lowercased() }
        }
        if words.isEmpty {
            delegate?.textSayingComplete()
        }
    }
}

extension Sentence {
    
    static func parseForData(dictionaryArray: [[String: String]], forLanguage language: LearningLanguage) -> [Sentence] {
        
        var sentences = [Sentence]()
        
        for dic in dictionaryArray {
//            let currentLocale = Locale.preferredLanguages[0]
            let appLang = LanguageService.shared.appLanguage
            let translated = dic[appLang.rawValue]
            let saying = dic[language.rawValue]
            
            if let translated = translated, let saying = saying {
                let sentence = Sentence(saying: saying, translation: translated)
                sentences.append(sentence)
            }
        }
        
        return sentences
    }
}
