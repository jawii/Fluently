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
}

class Sentence {
    let initialSentence: String
    var sentence: NSMutableAttributedString {
        didSet {
            delegate?.setText(sentence)
        }
    }
    var words: [String]
    let saidWords = [String]()
    
    weak var delegate: SentenceDelegate?
    
    init(saying: String) {
        self.initialSentence = saying
        self.words = saying.components(separatedBy: " ").map { $0.lowercased().stripped }
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes : [NSAttributedString.Key : Any ] = [
            NSAttributedString.Key.font : UIFont(name: "AvenirNext-Demibold", size: 32)!,
            NSAttributedString.Key.paragraphStyle : style
        ]
        self.sentence = NSMutableAttributedString(string: initialSentence, attributes: attributes)
    }
    
    func said(word: String) {
        if words.contains(word.lowercased()) {
            sentence = sentence.highlight([word], this: UIColor.green)
        }
        //check if sentence is said
    }
    
}
