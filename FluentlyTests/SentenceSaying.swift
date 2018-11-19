//
//  SentenceSaying.swift
//  FluentlyTests
//
//  Created by Jaakko Kenttä on 19/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import XCTest
@testable import Fluently

class SentenceSaying: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSentenceCompletion() {
        let sentence = Sentence(saying: "Hello. I'm Jaakko", translation: nil)
        sentence.said(word: "Hello")
        sentence.said(word: "Im")
        sentence.said(word: "Jaakko")
        XCTAssert(sentence.words.count == 0)
    }
    
    func testSentenceAmount() {
        LearningLanguage.allCases.forEach { learninglanguage in
//            print(learninglanguage.rawValue)
        }
        let sentenceService = SentenceService()
        
        let currentLanguages: [LearningLanguage] = [.finnish, .englishUK, .englishUS]
        currentLanguages.forEach { language in
            SentenceCategory.allCases.forEach { category in
                let sentences = sentenceService.fetchSentences(forLanguage: language, andForCategory: category)
                print(sentences.count)
                XCTAssert(sentences.count > 0, "Could not find sentences for \(language) and for category \(category)")
            }
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
