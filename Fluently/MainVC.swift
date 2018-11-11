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
    @IBOutlet weak var sentenceToSayTextView: UITextView!
    
    var listener: WordListener!
    /*
    var wordsHeared = [String]() {
        didSet {
            if let word = wordsHeared.last {
                if currentSentenceWords.contains(word.lowercased()) {
                    let attributedText = NSMutableAttributedString(attributedString: sentenceToSayTextView.attributedText)
                    let newText = attributedText.highlight([word], this: UIColor.green)
                    sentenceToSayTextView.attributedText = newText
                }
            }
        }
    }
 
    
    var currentSentence: String = "" {
        didSet {
            sentenceToSayTextView.text = currentSentence
            if listener != nil {
                self.listener.setContextualStrings(currentSentenceWords)
            }
        }
    }
    var currentSentenceWords: [String] {
        let words = currentSentence.components(separatedBy: " ")
            .map { $0.lowercased().stripped }
        return words
    }
    */
    
    var sentences = [
        Sentence(saying: "Moikka kaikille minun nimi on viivi. Tänään on isänpäivä. Nyt menen syömään. Moro"),
        Sentence(saying: "How are you doing today? HELP!"),
        Sentence(saying: "How are you doing today? HELP!"),
        Sentence(saying: "My name is Jack. What is your name? How many old are you?"),
        Sentence(saying: "How are you doing today? HELP!"),
        Sentence(saying: "How are you doing today? HELP!")
    ]
    
    var currentSentence: Sentence!
    var wordsHeared = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSentence = sentences.removeFirst()
        currentSentence.delegate = self
        sentenceToSayTextView.attributedText = currentSentence.sentence
        
//        listener = WordListener(locale: Locale(identifier: "en-US"))
        listener = WordListener(locale: Locale.init(identifier: "fi_FI"))
        listener.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(wordTapped(_:)))
        sentenceToSayTextView.isUserInteractionEnabled = true
        sentenceToSayTextView.addGestureRecognizer(tap)
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
        //"en-US"
        utterance.voice = AVSpeechSynthesisVoice(language: "fi_FI")
//        utterance.rate = 0.2
        let synth = AVSpeechSynthesizer()
        synth.delegate = self
        synth.speak(utterance)
        
    }
    
    @IBAction func recordButtonPressHandler(_ sender: UIButton) {
        if listener.audioEngine.isRunning {
            listener.stop()
        } else {
            listener.start()
        }
    }
    
    @IBAction func skipWord(_ sender: UIButton) {
        currentSentence = sentences.removeFirst()
    }
}

extension MainVC: SentenceDelegate {
    func setText(_ text: NSMutableAttributedString) {
        self.sentenceToSayTextView.attributedText = text
    }
    
    func setContextualStrings(to: [String]) {
        if listener != nil {
            listener.setContextualStrings(to)
        }
    }
}

extension MainVC: WordListenerDelegate {
    func wordsHeared(word: String) {
        if wordsHeared.last != word {
            print("Heared: \(word.lowercased())")
            wordsHeared.append(word.lowercased())
            currentSentence.said(word: word)
            throwWord(word: word)
        }
    }
    func throwWord(word: String) {
        //throw the word
        let xMax = self.view.frame.width + 100
        let xMin = CGFloat(50)
        let yMin = self.sentenceToSayTextView.frame.maxY
        let yMax = self.playButton.frame.minY
        
        let x = CGFloat.random(in: xMin...xMax)
        let y = CGFloat.random(in: yMin...yMax)
        let label = UILabel()
        label.frame = CGRect(x: x, y: y, width: 100, height: 50)
        label.adjustsFontSizeToFitWidth = true
        label.text = word
        
        self.view.addSubview(label)
        UIView.animate(withDuration: 1.5, animations: {
            label.alpha = 0
        }) { (_) in
            label.removeFromSuperview()
        }
    }
    
    
    func recordinStarted() {
        playButton.setImage(#imageLiteral(resourceName: "Recording"), for: .normal)
    }
    func recordingEnded() {
        playButton.setImage(#imageLiteral(resourceName: "Play Button"), for: .normal)
    }
}

extension MainVC: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        listener.stop()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        listener.start()
        
    }
}

