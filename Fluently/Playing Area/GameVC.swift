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
    @IBOutlet weak var wordsSaidLabel: UILabel!
    
    @IBOutlet weak var counterView: CounterView!
    
    var service: StatsService!
    
    var listener: WordListener!
    var category: SentenceCategory!
    
    var sentences = [Sentence]()
    var currentSentence: Sentence! {
        didSet {
            currentSentence.start()
            translatedTextLabel.text = currentSentence.translation
            counterView.addCount()
        }
    }
    // Keeps track of said words
    var wordsHeared = [String]()

    // Keep track of how many sentences have said
    var sentencesSaid = 0
    var maximumSentences = 5
    
    var correctWordsAmount = 0  {
        didSet {
            wordsSaidLabel.text = String(correctWordsAmount)
        }
    }
    
    // Synthesizer for speaking
    let synth = AVSpeechSynthesizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synth.delegate = self
        
        // Create counterView
        counterView.totalCount = 10
        
        let service = SentenceService()
        let learningLang = LanguageService.shared.learningLanguage
        sentences = service.fetchSentences(forLanguage: learningLang, andForCategory: self.category).shuffled()

        
        currentSentence = sentences.removeFirst()
        currentSentence.delegate = self
        currentSentence.start()
        
        if currentSentence.translation != currentSentence.initialSentence {
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
//        translatedTextLabel.layer.cornerRadius = 5
//        translatedTextLabel.layer.borderWidth = 1
//        translatedTextLabel.layer.borderColor = UIColor.darkGray.cgColor
        self.title = category.getCategoryName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener.stop()
        synth.stopSpeaking(at: .immediate)
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
            saySentenceLabel.text = NSLocalizedString("Say it", comment: "")
        } else {
            saySentenceLabel.text = NSLocalizedString("Saying...", comment: "")
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
        sentencesSaid += 1
        if sentencesSaid < maximumSentences {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                //            self.listener.stop()
                self.currentSentence = self.sentences.removeFirst()
                self.currentSentence.delegate = self
                self.currentSentence.start()
            }
        } else {
            // Game End
            print("Game Complete!")
            let lang = LanguageService.shared.learningLanguage
            service.addStats(forLanguage: lang, andCategory: category, words: correctWordsAmount, seconds: 5)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension GameVC: WordListenerDelegate {
    func wordsHeared(word: String) {
        
        let lastWord = wordsHeared.last
        let secondLast: String?
        if wordsHeared.count >= 2 {
            secondLast = wordsHeared[wordsHeared.count - 2]
        } else {
            secondLast = nil
        }
        
        if lastWord != word && secondLast != word {
            wordsHeared.append(word.lowercased())
            let wasCorrect = currentSentence.said(word: word)
            if wasCorrect { correctWordsAmount += 1 }
            
            recordButtonView.shootWord(word: word.lowercased())
        }
    }
    
    func recordinStarted() {
        recordButtonBottomLabel.text = NSLocalizedString("RECORDING", comment: "")
        recordButtonBottomLabel.textColor = GlobalConstants.Color.coral
        recordButtonView.recordingStarted()
    }
    func recordingEnded() {
        recordButtonBottomLabel.text = NSLocalizedString("START", comment: "")
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
        saySentenceLabel.text = NSLocalizedString("Say it", comment: "")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        saySentenceLabel.text = NSLocalizedString("Say it", comment: "")
        recordButtonView.enableRecording()
        sentenceToSayTextView.attributedText = currentSentence.sentenceAttrString
        
    }
}

