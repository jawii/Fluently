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
    
    @IBOutlet weak var sentenceCollectionView: UICollectionView!
    
    
    private let titleHeight:CGFloat = 100
    let statsService = StatsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = GlobalConstants.Color.havelockBlue
        
        sentenceCollectionView.dataSource = self
        sentenceCollectionView.delegate = self
        sentenceCollectionView.register(SentenceCategoryCell.self, forCellWithReuseIdentifier: "SentenceCategoryCell")
        sentenceCollectionView.register(UINib(nibName: "SentenceCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SentenceCategoryCell")
        sentenceCollectionView.layer.masksToBounds = false // prevent contentview shadows clipping
        sentenceCollectionView.reloadData()
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

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.sentenceCollectionView {
            return SentenceCategory.allCases.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentenceCategoryCell", for: indexPath) as? SentenceCategoryCell else {
            return UICollectionViewCell()
        }
        
        cell.setupView(forCategory: SentenceCategory.allCases[indexPath.row])
    
        return cell
        
    }
    
    
}
