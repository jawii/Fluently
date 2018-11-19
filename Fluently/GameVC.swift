//
//  ViewController.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 08/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit
import AVFoundation


class GameVC: UIViewController {
    
    @IBOutlet weak var sentenceToSayTextView: UITextView!
    @IBOutlet weak var recordButtonView: RecordButtonView!
    @IBOutlet weak var saySentenceButton: UIButton!
    @IBOutlet weak var skipSentenceButton: UIButton!
    
    
    var listener: WordListener!
    
    var sentences = [Sentence]()
    var currentSentence: Sentence! {
        didSet {
            currentSentence.start()
        }
    }
    // Keeps track of said words
    var wordsHeared = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        saySentenceButton.alignImageAndTitleVertically()
//        skipSentenceButton.alignImageAndTitleVertically()
        
        let service = SentenceService()
        let learningLang = LanguageService.shared.learningLanguage
        sentences = service.fetchSentences(forLanguage: learningLang, andForCategory: .smallTalk).shuffled()
        
        
        currentSentence = sentences.removeFirst()
        currentSentence.delegate = self
        currentSentence.start()
        
        
        
        listener = WordListener(locale: Locale(identifier: learningLang.rawValue))
        listener.delegate = self
        
        // Add tap to word. Say the word when tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(wordTapped(_:)))
        sentenceToSayTextView.isUserInteractionEnabled = true
        sentenceToSayTextView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(recordButtonPressHandler))
        recordButtonView.isUserInteractionEnabled = true
        recordButtonView.addGestureRecognizer(tap1)
    }
    
    @objc func wordTapped(_ tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.location(in: sentenceToSayTextView)
        if let detectedWord = sentenceToSayTextView.getWordAtPosition(point) {
            sayWord(word: detectedWord)
        }
    }
    
    @objc func sayWord(word: String) {
        listener.stop()
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: LanguageService.shared.learningLanguage.rawValue)
        utterance.rate = 0.8
        let synth = AVSpeechSynthesizer()
        synth.delegate = self
        synth.speak(utterance)
        
    }
    
    @objc func recordButtonPressHandler() {
        if listener.audioEngine.isRunning {
            listener.stop()
        } else {
            listener.start()
        }
    }
    
    @IBAction func skipWord(_ sender: UIButton) {
        currentSentence = sentences.removeFirst()
        currentSentence.delegate = self
        currentSentence.start()
    }
    
    @IBAction func saySentenceButtonHandler(_ sender: Any) {
        sayWord(word: currentSentence.initialSentence)
    }
}

extension GameVC: SentenceDelegate {
    func setText(_ text: NSMutableAttributedString) {
        self.sentenceToSayTextView.attributedText = text
    }
    
    func setContextualStrings(to strings: [String]) {
        if listener != nil {
            listener.setContextualStrings(strings)
        }
    }
    func textSayingComplete() {
        print("Word complete!")
    }
}

extension GameVC: WordListenerDelegate {
    func wordsHeared(word: String) {
        if wordsHeared.last != word {
            wordsHeared.append(word.lowercased())
            currentSentence.said(word: word)
            recordButtonView.shootWord(word: word.lowercased())
        }
    }
    
    func recordinStarted() {
        recordButtonView.recordingStarted()
    }
    func recordingEnded() {
        recordButtonView.recordingStopped()
    }
}

extension GameVC: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("Synthesizer started")
        recordButtonView.isUserInteractionEnabled = false
        saySentenceButton.tintColor = UIColor.black
        listener.stop()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Synthesizer stopped")
        recordButtonView.isUserInteractionEnabled = true
        saySentenceButton.tintColor = UIColor.blue
        listener.start()
    }
}

