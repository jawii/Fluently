//
//  LangTableViewCell.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 24/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class LangTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var languageName: UILabel!
    @IBOutlet weak var wordsSaidLabel: UILabel!
    @IBOutlet weak var timePracticedLabel: UILabel!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(languageSelectionHandler))
        selectedLabel.addGestureRecognizer(tapGesture)
    }
    
    func configureCell(forLanguage language: LearningLanguage, stats: Statistics) {
        flagImageView.image = language.getFlagImage()
        languageName.text = language.getLanguageName()
        
        let wordEnd = NSLocalizedString("words", comment: "")
        let currentTime = TimeInterval(stats.time)
        
        wordsSaidLabel.text = "\(stats.words) \(wordEnd)"
        timePracticedLabel.text = currentTime.convertToStringDuration()
        
        if LanguageService.shared.learningLanguage == language {
            languageSelectionHandler()
        } else {
            selectedImageView.isHidden = true
            selectedLabel.text = NSLocalizedString("SELECT", comment: "")
            selectedLabel.textColor = UIColor.darkGray
        }
    }
    
    @objc func languageSelectionHandler() {
        print("Language Selected.")
    }
}
