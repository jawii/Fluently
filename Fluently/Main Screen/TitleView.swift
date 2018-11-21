//
//  TitleView.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 21/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class TitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        self.backgroundColor = GlobalConstants.Color.havelockBlue
        
        let label = UILabel()
        label.text = "FLUENTLY"
        label.textAlignment = .center
        label.font = UIFont(name: "MarkerFelt-Wide", size: 60)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 5.0
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.masksToBounds = false
        label.textColor = UIColor.white
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }

}
