//
//  SentenceCategoryCell.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 25/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

protocol SentenceCategoryTableViewCellDelegate: class {
    func didTapButtonFor(category: SentenceCategory)
}

class SentenceCategoryTableCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryDescriptionLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    
    var category: SentenceCategory!
    weak var delegate: SentenceCategoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCellForCategory(_ category: SentenceCategory, wordCount: Int) {
        self.category = category
        
        categoryImageView.image = category.getCategoryImage()
        categoryTitle.text = category.getCategoryName()
        categoryDescriptionLabel.text = category.getDetailText()
        
        let suffix = NSLocalizedString("words said", comment: "")
        wordCountLabel.text = "\(wordCount) \(suffix)"
    }
    
    
    
    @IBAction func practiseBtnTapHandler(_ sender: Any) {
        delegate?.didTapButtonFor(category: self.category)
    }
    
}
