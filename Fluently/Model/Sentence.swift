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
    func setContextualStrings(to: [String])
    func textSayingComplete()
}

class Sentence {
    let translation: String?
    
    let initialSentence: String
    var sentenceAttrString: NSMutableAttributedString {
        didSet {
            delegate?.setText(sentenceAttrString)
            delegate?.setContextualStrings(to: words)
        }
    }
    var words: [String] {
        didSet {
//            print("Words: \(words)")
        }
    }
    
    weak var delegate: SentenceDelegate?
    
    init(saying: String, translation: String?) {
        self.initialSentence = saying
        
        // Removes all special characters from word and puts them on the list
        self.words = saying.components(separatedBy: " ").map { $0.lowercased().stripped }
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes : [NSAttributedString.Key : Any ] = [
            NSAttributedString.Key.font : UIFont(name: "AvenirNext-Demibold", size: 32)!,
            NSAttributedString.Key.paragraphStyle : style,
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        self.sentenceAttrString = NSMutableAttributedString(string: initialSentence, attributes: attributes)
        
        self.translation = translation
    }
    func start() {
        delegate?.setText(sentenceAttrString)
        delegate?.setContextualStrings(to: words)
    }
    
    func said(word: String) -> Bool {
        // Return if words is empty
        guard !words.isEmpty else { return false }
        
        var isInSentence = false
        
        let wordLowerCased = word.lowercased()
        let initialLowerCased = initialSentence.lowercased()
        
        print("Heard: \(wordLowerCased)")
        if words.contains(wordLowerCased) ||
           words.contains(wordLowerCased.stripped) ||
           initialLowerCased.contains(wordLowerCased) ||
           initialLowerCased.contains(wordLowerCased.stripped) {
            print("Words contains!: \(wordLowerCased)")
            
            sentenceAttrString = sentenceAttrString.highlight([word], this: UIColor.green)
            self.removeFromWord(word: wordLowerCased)
            isInSentence = true
        }
        
        if words.isEmpty {
            delegate?.textSayingComplete()
        }
        
        return isInSentence
    }
    private func removeFromWord(word: String) {
        print("Removing!: \(word)")
        print(word.stripped)
        print("Words: \(words)")
        self.words = words.filter { $0 != word && $0 != word.stripped }
        print("Words: \(words)")
    }
    
    func highLightTappedWord(word: String) {
        // create copy
        let copy = sentenceAttrString.mutableCopy() as! NSMutableAttributedString
        let highlightOneWord = copy.highlight([word], this: GlobalConstants.Color.havelockBlue)
        delegate?.setText(highlightOneWord)
    }
    func highlightWholeWord() {
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: GlobalConstants.Color.havelockBlue
        ]
        let copy = sentenceAttrString.mutableCopy() as! NSMutableAttributedString
        copy.addAttributes(attrs, range: NSRange(location: 0, length: copy.length))
        delegate?.setText(copy)
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
