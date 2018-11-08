//
//  WordListener.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 08/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation
import Speech

protocol WordListenerDelegate :class {
    func wordsHeared(bestResult: String, others: [String])
}

class WordListener {
    
    private var locale: Locale
    private let speechRegonizer: SFSpeechRecognizer
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    weak var delegate: WordListenerDelegate?
    var isAuthorized: Bool = false
    
    init(locale: Locale) {
        self.locale = locale
        self.speechRegonizer = SFSpeechRecognizer(locale: locale)!
        requestAuthorization()
    }
    
    private func requestAuthorization () {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isEnabled = false
            switch authStatus {  //5
            case .authorized:
                isEnabled = true
                
            case .denied:
                isEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.isAuthorized = isEnabled
            }
        }
    }
    
    func startRecording() {
        
        // Checks if task is running
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create session to prepare for the audio recording
        let audioSession = AVAudioSession.sharedInstance()
        do {
            let audioSessionCategory = AVAudioSession.Category.record
            let audioSessionMode = AVAudioSession.Mode.spokenAudio
            let audioSessionOptions = AVAudioSession.CategoryOptions.defaultToSpeaker
            
            try audioSession.setCategory(audioSessionCategory, mode: audioSessionMode, options: audioSessionOptions)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("AudioSession properties weren't set because of and error.")
        }
        
        // Create audio request for passing data to Apple Server's
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRegonizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil {
                
                if let bestTranscription = result?.bestTranscription.formattedString {
                    let others = result!.transcriptions.map { $0.formattedString }.filter { $0 != bestTranscription}
                    self.delegate?.wordsHeared(bestResult: bestTranscription, others: others)
                    self.stop()
                }
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine could not start because of an error.")
        }
        
    }
    
    func start() {
        print("Start Record")
        startRecording()
    }
    
    func stop() {
        guard audioEngine.isRunning else { return }
        print("Stop Record")
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
}
