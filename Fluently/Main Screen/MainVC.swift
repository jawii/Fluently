//
//  MainVC.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 21/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {
    
    @IBOutlet weak var statsView: MainStatsView!
    @IBOutlet weak var currentLanguageFlagImageView: UIImageView!
    @IBOutlet weak var learningLangNameLabel: UILabel!
    
    private let titleHeight:CGFloat = 100
    let statsService = StatsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = GlobalConstants.Color.havelockBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statsView.setupView(forService: statsService)
        currentLanguageFlagImageView.image = UIImage(named: LanguageService.shared.learningLanguage.rawValue)
        learningLangNameLabel.text = LanguageService.shared.getNameForLanguage(LanguageService.shared.learningLanguage)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return titleHeight
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: titleHeight)
        return TitleView(frame: rect)
    }
    
}
