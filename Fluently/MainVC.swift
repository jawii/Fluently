//
//  ViewController.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 08/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var listener: WordListener!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener = WordListener(locale: Locale(identifier: "en-US"))
        listener.delegate = self
    }
    @IBAction func recordButtonPressHandler(_ sender: UIButton) {
        listener.start()
    }
}

extension MainVC: WordListenerDelegate {
    func wordsHeared(bestResult: String, others: [String]) {
        print("Best: \(bestResult)")
        print("Others: \(others)")
    }
    
    
}

