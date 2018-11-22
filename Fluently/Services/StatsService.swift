//
//  StatsService.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 22/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation

struct LanguageStats: Codable {
    var wordsSaid: Int
    var secondsPlayed: Int
}

class StatsService {
    
    static let shared = StatsService()
    
    var languageStats = [LanguageStats]()
    
    
    func createEmptyStatisticFile() -> [LanguageStats] {
        
        
        
        return [LanguageStats]()
    }
    
    func fetchStats() {
        guard let plistData = try? Data(contentsOf: statisticFileUrl) else {
            languageStats = createEmptyStatisticFile()
            return
        }
        
        let decoder = PropertyListDecoder()
        languageStats =  try! decoder.decode([LanguageStats].self, from: plistData)
    }
    
    func saveStats() {
        
    }
    
    
    
    private let documentsDirectoryURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!
    
    private var statisticFileUrl: URL {
        let url = documentsDirectoryURL.appendingPathComponent("Stats").appendingPathExtension("plist")
        print(url)
        return url
    }
}
