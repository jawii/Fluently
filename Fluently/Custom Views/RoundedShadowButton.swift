//
//  RoundedShadowButton.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 25/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton{

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    func setupButton() {
        self.backgroundColor = GlobalConstants.Color.havelockBlue
        self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.cornerRadius = 6.0
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        self.contentEdgeInsets = UIEdgeInsets(top: 5,left: 10,bottom: 5,right: 10)
        
        //Add shadow
        /*
         self.layer.shadowColor = UIColor.black.cgColor
         self.layer.shadowOffset = CGSize(width: 6.0, height: 6.0)
         self.layer.shadowRadius = 10.0
         self.layer.shadowOpacity = 0.8
         self.layer.masksToBounds = false
         self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
         */
        // Add shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 3.0
        
    }
}
