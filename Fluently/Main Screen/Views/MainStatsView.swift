//
//  MainStatsView.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 22/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class MainStatsView: RoundedView {
        
    // MARK:- Outlets
    @IBOutlet private weak var flag: UIImageView!
    @IBOutlet private weak var currentWordAmountLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    
    @IBOutlet private weak var totalWordAmountLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(forService statsService: StatsService) {
        let currentLang = LanguageService.shared.learningLanguage
        
        flag.image = UIImage(named: currentLang.rawValue)
        
        let stats = StatsValues(service: statsService)
        
        let wordEnd = NSLocalizedString("words", comment: "")
        
        let currentLangStats = stats.getStatsForLang(currentLang)
        let currentTime = TimeInterval(currentLangStats.time)
        currentWordAmountLabel.text = "\(currentLangStats.words) \(wordEnd)"
        currentTimeLabel.text = currentTime.convertToStringDuration()
        
        let totalStats = stats.getTotalStats()
        let totalTime = TimeInterval(totalStats.time)
        totalWordAmountLabel.text = "\(totalStats.words) \(wordEnd)"
        totalTimeLabel.text = totalTime.convertToStringDuration()
    }

}
