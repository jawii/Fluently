//
//  StatsService.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 22/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import Foundation


typealias Statistics = (words: Int, time: Int)

/// Returns Statistics for Current language
struct StatsValues {
    
    var service: StatsService

    func getStatsForLang(_ language: LearningLanguage) -> Statistics {
        let stats = service.languageStats.filter { $0.languageName == language.rawValue }.first!
        
        
        // Go trough categories
        var wordCount = 0
        for category in SentenceCategory.allCases {
            wordCount += stats.wordsSaid[category.rawValue] ?? 0
        }
        
        return (words: wordCount, time: stats.secondsPlayed)
    }
    func getTotalStats() -> Statistics {
        var returnStats: Statistics = (words: 0, time: 0)
        LearningLanguage.allCases.forEach { lang in
            let currentStats = getStatsForLang(lang)
            returnStats.time += currentStats.time
            returnStats.words += currentStats.words
        }
        return returnStats
    }
    
    func wordsForCategory(_ category: SentenceCategory) -> Int {
        var wordCount = 0
        for language in service.languageStats {
            let langWords = language.wordsSaid[category.rawValue] ?? 0
            wordCount += langWords
        }
        return wordCount
    }
}

struct LanguageStats: Codable {
    var languageName: String
    var wordsSaid: [String: Int]
    var secondsPlayed: Int
    
    mutating func addStats(forCategory category: SentenceCategory, words: Int, seconds: Int) {
        let dictKey = category.rawValue
        let oldValue = self.wordsSaid[dictKey]
        self.wordsSaid[dictKey] = (oldValue ?? 0) + words
        self.secondsPlayed += seconds
    }
}

class StatsService {

    private var _languageStats = [LanguageStats]()
    var languageStats: [LanguageStats] {
        get {
            if _languageStats.isEmpty {
                _languageStats = fetchStats()
                saveStats()
            }
            return _languageStats
        }
        
        set {
            _languageStats = newValue
        }
    }
    
    private func createEmptyStatisticFile() -> [LanguageStats] {
        var emptylanguageStats = [LanguageStats]()
        LearningLanguage.allCases.forEach {
            let language = LanguageStats(languageName: $0.rawValue, wordsSaid: [String: Int](), secondsPlayed: 0)
            emptylanguageStats.append(language)
        }
        return emptylanguageStats
    }
    
    private func fetchStats() -> [LanguageStats] {
        guard let plistData = try? Data(contentsOf: statisticFileUrl) else {
            debugPrint("Creating Empty Languages stats file...")
            return createEmptyStatisticFile()
        }
        debugPrint("Fetching the saved stats file")
        let decoder = PropertyListDecoder()
        return try! decoder.decode([LanguageStats].self, from: plistData)
    }
    
    private func saveStats() {
        debugPrint("Saving Stats...")
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(_languageStats)  {
            try? data.write(to: statisticFileUrl)
        }
    }
    
    
    //---------------------
    // FILE URLS
    //-----------------------
    private let documentsDirectoryURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!
    
    private var statisticFileUrl: URL {
        let url = documentsDirectoryURL.appendingPathComponent("Stats").appendingPathExtension("plist")
        print(url)
        return url
    }
}
