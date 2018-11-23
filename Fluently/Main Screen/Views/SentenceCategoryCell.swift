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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(forCategory category: SentenceCategory) {
        nameLabel.text = category.rawValue
        
        categoryImageView.image = UIImage(named: category.rawValue)
    }

}
