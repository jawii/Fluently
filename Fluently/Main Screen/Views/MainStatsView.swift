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
        let currentLangStats = stats.getStatsForLang(currentLang)
        currentWordAmountLabel.text = "\(currentLangStats.words) words"
        currentTimeLabel.text = "\(currentLangStats.time) seconds"
        
        let totalStats = stats.getTotalStats()
        totalWordAmountLabel.text = "\(totalStats.words) words"
        totalTimeLabel.text = "\(totalStats.time) seconds"
    }

}
