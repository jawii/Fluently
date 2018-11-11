//
//  WordFetcher.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 08/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

class WordFetcher {
    private let file = "words2"
    let text = ""
    
    func readWordsFromFile() -> [String] {
        let path = Bundle.main.path(forResource: file, ofType: "txt")!
        let content = try! String.init(contentsOfFile: path)
        return content.components(separatedBy: "\n")
    }
    
    func fetchWords(completion: @escaping (_ words: Quote?, _ error: Error?) -> ()) {
        let url = "https://talaikis.com/api/quotes/random/"
        let request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, error)
                return
            } else {
                if let data = data {
//                    let result = String(data: data, encoding: String.Encoding.ascii)
                    let decoder = JSONDecoder()
                    let quote = try! decoder.decode(Quote.self, from: data)
                    completion(quote, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
        task.resume()
    }
}

class Quote: Codable {
    let quote: String
    let author: String
    let cat: String
}
