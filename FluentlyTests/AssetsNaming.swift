//
//  AssetsNaming.swift
//  FluentlyTests
//
//  Created by Jaakko Kenttä on 22/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import XCTest
@testable import Fluently

class AssetsNaming: XCTestCase {



    func test() {
        LearningLanguage.allCases.forEach {
            let image = UIImage(named: $0.rawValue)
            XCTAssertNotNil(image, "Could not find imagename \($0.rawValue)")
        }
    }


}
