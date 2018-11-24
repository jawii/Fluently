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
    }
    
    func configureCell(forLanguage language: LearningLanguage) {
        flagImageView.image = language.getFlagImage()
        languageName.text = language.getLanguageName()
        
    }
}
