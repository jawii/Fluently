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
        setupView()
    }
    
    func setupView() {
        
    }

}
