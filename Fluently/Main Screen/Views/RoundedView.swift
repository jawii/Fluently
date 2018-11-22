//
//  RoundedView.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 22/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }

}
