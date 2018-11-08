//
//  ViewController.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 08/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var wordsToSayLabel: UILabel!
    
    var listener: WordListener!
    var wordsHeared = [String]()
    var words = [String]()
    var currentWord: String = "" {
        didSet {
            wordsToSayLabel.text = currentWord
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wordfetcher = WordFetcher()
        words = wordfetcher.readWords().shuffled().filter { $0.count > 2 }
        print("Words: count", words.count)
        
        currentWord = words.removeFirst()
        
        listener = WordListener(locale: Locale(identifier: "en-US"))
        listener.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sayWord))
        wordsToSayLabel.isUserInteractionEnabled = true
        wordsToSayLabel.addGestureRecognizer(tap)
    }
    @objc func sayWord() {
        let utterance = AVSpeechUtterance(string: currentWord)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    @IBAction func recordButtonPressHandler(_ sender: UIButton) {
        listener.start()
    }
    
    @IBAction func skipWord(_ sender: UIButton) {
        currentWord = words.removeFirst()
    }
}

extension MainVC: WordListenerDelegate {
    func wordsHeared(word: String) {
        if wordsHeared.last != word {
            print("Heared: \(word)")
            wordsHeared.append(word)
            
            if word == currentWord {
                currentWord = words.removeFirst()
            }
        }
    }
}

