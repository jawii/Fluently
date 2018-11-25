//
//  SentenceCategories.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 23/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

enum SentenceCategory: String, CaseIterable {
    case smallTalk = "smallTalk"
    case jobInterview = "jobInterview"
    case restaurant = "restaurant"
    case travelling = "travelling"
}

extension SentenceCategory {
    func getCategoryName() -> String {
        switch self {
        case .smallTalk:
            return NSLocalizedString("Small Talk", comment: "")
        case .jobInterview:
            return NSLocalizedString("Job Interview", comment: "")
        case .restaurant:
            return NSLocalizedString("Restaurant", comment: "")
        case .travelling:
            return NSLocalizedString("Travelling", comment: "")
        }
    }
    
    func getCategoryImage() -> UIImage {
        switch self {
        case .smallTalk:
            let image = #imageLiteral(resourceName: "smallTalk")
            return image
        case .jobInterview:
            let image = #imageLiteral(resourceName: "jobinterview")
            return image
        case .restaurant:
            let image = #imageLiteral(resourceName: "restaurant")
            return image
        case .travelling:
            let image = #imageLiteral(resourceName: "travelling")
            return image
        }
    }
    
    func getDetailText() -> String {
        let returnValue: String
        switch self {
        case .smallTalk:
            returnValue = NSLocalizedString("Basic Sentences.", comment: "")
        case .jobInterview:
            returnValue = NSLocalizedString("Get the Job!", comment: "")
        case .restaurant:
            returnValue = NSLocalizedString("Pizza time.", comment: "")
        case .travelling:
            returnValue = NSLocalizedString("Around the world.", comment: "")
        }
        #warning("Add localized strings")
        
        return returnValue
    }
}
