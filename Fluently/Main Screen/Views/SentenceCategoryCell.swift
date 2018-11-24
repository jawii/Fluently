//
//  SentenceCategoryCell.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 23/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class SentenceCategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
    }
    
    func setupView(forCategory category: SentenceCategory) {
        nameLabel.text = category.getCategoryName()
        categoryImageView.image = category.getCategoryImage()
        
        // Initialization code
        
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backView.layer.shadowRadius = 4
        backView.layer.shadowOpacity = 0.3
        
        backView.layer.cornerRadius = 5
    }

}
