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
    
    
    @IBOutlet weak var translatedTextLabel: UILabel!
    @IBOutlet weak var sentenceToSayTextView: UITextView!
    @IBOutlet weak var recordButtonView: RecordButtonView!
    @IBOutlet weak var recordButtonBottomLabel: UILabel!
    
    
    @IBOutlet weak var saySentenceButton: UIButton!
    @IBOutlet weak var saySentenceLabel: UILabel!
    
    @IBOutlet weak var skipSentenceButton: UIButton!
    
    
    var listener: WordListener!
    var category: SentenceCategory!
    
    var sentences = [Sentence]()
    var currentSentence: Sentence! {
        didSet {
            currentSentence.start()
            translatedTextLabel.text = currentSentence.translation
        }
    }
    // Keeps track of said words
    var wordsHeared = [String]()
    
    // Synthesizer for speaking
    let synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synth.delegate = self
        
        let service = SentenceService()
        let learningLang = LanguageService.shared.learningLanguage
        sentences = service.fetchSentences(forLanguage: learningLang, andForCategory: self.category).shuffled()

        
        currentSentence = sentences.removeFirst()
        currentSentence.delegate = self
        currentSentence.start()
        
        if LanguageService.shared.appLanguage != learningLang {
            translatedTextLabel.text = currentSentence.translation
        } else {
            translatedTextLabel.isHidden = true
        }
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        translatedTextLabel.layer.cornerRadius = 5
        translatedTextLabel.layer.borderWidth = 1
        translatedTextLabel.layer.borderColor = UIColor.darkGray.cgColor
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
            listener.setContextualStrings(strings)
        }
    }
    
    func textSayingComplete() {
        print("Word complete!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.listener.stop()
            self.currentSentence = self.sentences.removeFirst()
            self.currentSentence.delegate = self
            self.currentSentence.start()
        }
    }
}

extension GameVC: WordListenerDelegate {
    func wordsHeared(word: String) {
//        print("HEARED: \(word)")
        
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
        recordButtonView.disableRecording()
        
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        recordButtonView.enableRecording()
        sentenceToSayTextView.attributedText = currentSentence.sentenceAttrString
        saySentenceLabel.text = "Say it"
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        saySentenceLabel.text = "Say it"
        recordButtonView.enableRecording()
        sentenceToSayTextView.attributedText = currentSentence.sentenceAttrString
        
    }
}

