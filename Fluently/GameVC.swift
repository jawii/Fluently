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
    @IBOutlet weak var saySentenceLabel: UILabel!
    
    @IBOutlet weak var skipSentenceButton: UIButton!
    
    @IBOutlet weak var recordButtonBottomLabel: UILabel!
    
    
    var listener: WordListener!
    
    var sentences = [Sentence]()
    var currentSentence: Sentence! {
        didSet {
            currentSentence.start()
        }
    }
    // Keeps track of said words
    var wordsHeared = [String]()
    
    let synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        saySentenceButton.alignImageAndTitleVertically()
//        skipSentenceButton.alignImageAndTitleVertically()
        synth.delegate = self
        
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
        
        // Add gestures to recordbutton
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(recordButtonPressHandler))
        recordButtonView.isUserInteractionEnabled = true
        recordButtonView.addGestureRecognizer(tap1)
    }
    
    @objc func wordTapped(_ tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.location(in: sentenceToSayTextView)
        if let detectedWord = sentenceToSayTextView.getWordAtPosition(point) {
            currentSentence.highLightTappedWord(word: detectedWord)
            sayWord(word: detectedWord)
        }
    }
    
    @objc func sayWord(word: String) {
        listener.stop()
        let utterance = AVSpeechUtterance(string: word.lowercased())
        utterance.voice = AVSpeechSynthesisVoice(language: LanguageService.shared.learningLanguage.rawValue)
        synth.speak(utterance)
    }
    
    @objc func recordButtonPressHandler() {
        if !recordButtonView.isRecordingEnabled {
            return
        }
        
        if listener.audioEngine.isRunning {
            listener.stop()
        } else {
            listener.start()
        }
    }
    
    @IBAction func skipWord(_ sender: UIButton) {
        listener.stop()
        currentSentence = sentences.removeFirst()
        currentSentence.delegate = self
        currentSentence.start()
    }
    
    @IBAction func saySentenceButtonHandler(_ sender: Any) {
        if synth.isSpeaking {
            synth.stopSpeaking(at: AVSpeechBoundary.immediate)
            saySentenceLabel.text = "Say it"
        } else {
            saySentenceLabel.text = "Saying..."
            listener.stop()
            currentSentence.highlightWholeWord()
            sayWord(word: currentSentence.initialSentence)
        }
        
    }
}

extension GameVC: SentenceDelegate {
    func setText(_ text: NSMutableAttributedString) {
        self.sentenceToSayTextView.attributedText = text
    }
    
    func setContextualStrings(to strings: [String]) {
        if listener != nil {
            print("Set contextual strings!")
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
            _ = currentSentence.said(word: word)
            recordButtonView.shootWord(word: word.lowercased())
        }
    }
    
    func recordinStarted() {
        recordButtonBottomLabel.text = "RECORDING"
        recordButtonBottomLabel.textColor = GlobalConstants.Color.coral
        recordButtonView.recordingStarted()
    }
    func recordingEnded() {
        recordButtonBottomLabel.text = "START"
        recordButtonBottomLabel.textColor = GlobalConstants.Color.havelockBlue
        recordButtonView.recordingStopped()
    }
}

extension GameVC: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
//        recordButtonView.isUserInteractionEnabled = false
        recordButtonView.disableRecording()
        
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        recordButtonView.isUserInteractionEnabled = true
        recordButtonView.enableRecording()
        sentenceToSayTextView.attributedText = currentSentence.sentenceAttrString
        saySentenceLabel.text = "Say it"
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
//        recordButtonView.isUserInteractionEnabled = true
        saySentenceLabel.text = "Say it"
        recordButtonView.enableRecording()
        sentenceToSayTextView.attributedText = currentSentence.sentenceAttrString
        
    }
}

