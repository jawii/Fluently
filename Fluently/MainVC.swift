//
//  ViewController.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 08/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var wordsToSayLabel: UILabel!
    
    var listener: WordListener!
    var wordsHeared = [String]()
    var words = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wordfetcher = WordFetcher()
        words = wordfetcher.readWords()
        print("Words: count", words.count)
        
        listener = WordListener(locale: Locale(identifier: "en-US"))
        listener.delegate = self
    }
    
    @IBAction func recordButtonPressHandler(_ sender: UIButton) {
        listener.start()
    }
}

extension MainVC: WordListenerDelegate {
    func wordsHeared(word: String) {
        if wordsHeared.last != word {
            print("Heared: \(word)")
            wordsHeared.append(word)
        }
    }
}

