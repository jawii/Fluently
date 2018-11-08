//
//  WordFetcher.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 08/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

class WordFetcher {
    private let file = "words"
    let text = ""
    
    func readWords() -> [String] {
        let path = Bundle.main.path(forResource: file, ofType: "txt")!
        let content = try! String.init(contentsOfFile: path)
        return content.components(separatedBy: "\n")
    }
}
