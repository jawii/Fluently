//
//  LanguageStats.swift
//  FluentlyTests
//
//  Created by Jaakko Kenttä on 22/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import XCTest
@testable import Fluently

class LanguageStats: XCTestCase {
    
    var service = StatsService()

    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStatistics() {
        // Check that there is stats for every language
        XCTAssert(service.languageStats.count == LearningLanguage.allCases.count)
        
        // add stats and check if it's valid
        
        
    }


}
