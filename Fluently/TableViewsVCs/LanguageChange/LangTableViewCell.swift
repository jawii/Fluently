//
//  LangTableViewCell.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 24/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

protocol LanguageCellDelegate: class {
    func appLanguageDidSet()
}

class LangTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var languageName: UILabel!
    @IBOutlet private weak var wordsSaidLabel: UILabel!
    @IBOutlet private weak var timePracticedLabel: UILabel!
    
    @IBOutlet private weak var selectedImageView: UIImageView!
    @IBOutlet private weak var selectedLabel: UILabel!
    
    // MARK:- Delegate
    weak var delegate: LanguageCellDelegate?
    
    var language: LearningLanguage!
    var isSelectedLanguage: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedLabel.isUserInteractionEnabled = true
    }
    
    func configureCell(forLanguage language: LearningLanguage, stats: Statistics) {
        
        self.language = language
        
        flagImageView.image = language.getFlagImage()
        languageName.text = language.getLanguageName()
        
        let wordEnd = NSLocalizedString("words", comment: "")
        let currentTime = TimeInterval(stats.time)
        
        wordsSaidLabel.text = "\(stats.words) \(wordEnd)"
        timePracticedLabel.text = currentTime.convertToStringDuration()
        
        self.isSelectedLanguage = LanguageService.shared.learningLanguage == language
        if isSelectedLanguage { self.setSelected() } else { deselect() }
    }
    @IBAction func selectionBtnTapHandler(_ sender: Any?) {
        
        if isSelectedLanguage {
            return
        } else {
            isSelectedLanguage = true
            setSelected()
        }
    }
    
    func setSelected() {
        LanguageService.shared.learningLanguage = self.language

        UIView.animate(withDuration: 0.25, animations: {
            self.selectedImageView.isHidden = false
            self.selectedLabel.text = NSLocalizedString("SELECTED", comment: "")
            self.selectedLabel.textColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        }) { (_) in
            self.selectedImageView.isHidden = false
            self.layoutIfNeeded()
        }
        self.delegate?.appLanguageDidSet()
        
        
    }
    func deselect() {
        self.isSelectedLanguage = false
        UIView.animate(withDuration: 0.25) {
            self.selectedImageView.isHidden = true
            self.selectedLabel.text = NSLocalizedString("SELECT", comment: "")
            self.selectedLabel.textColor = UIColor.darkGray
        }
    }
}


