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
    @IBOutlet weak var changeLanguageBtn: RoundedShadowButton!
    
    @IBOutlet weak var sentenceCollectionView: UICollectionView!
    
    
    private let titleHeight:CGFloat = 100
    let statsService = StatsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fit button titletext to available space
        changeLanguageBtn.titleLabel?.numberOfLines = 1
        changeLanguageBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        changeLanguageBtn.titleLabel?.lineBreakMode = .byClipping
        
        
        sentenceCollectionView.dataSource = self
        sentenceCollectionView.delegate = self
        sentenceCollectionView.register(SentenceCategoryCell.self, forCellWithReuseIdentifier: "SentenceCategoryCell")
        sentenceCollectionView.register(UINib(nibName: "SentenceCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SentenceCategoryCell")
        sentenceCollectionView.layer.masksToBounds = false // prevent contentview shadow clipping
        sentenceCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statsView.setupView(forService: statsService)
        currentLanguageFlagImageView.image = UIImage(named: LanguageService.shared.learningLanguage.rawValue)
        learningLangNameLabel.text = LanguageService.shared.getNameForLanguage(LanguageService.shared.learningLanguage)
        
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarView?.backgroundColor = GlobalConstants.Color.havelockBlue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeLanguage", let destVC = segue.destination as? LanguageListVC  {
            destVC.hidesBottomBarWhenPushed = true
            destVC.service = statsService
        }
        
        if segue.identifier == "categoryList", let destVC = segue.destination as? SentenceCategoryVC {
            destVC.hidesBottomBarWhenPushed = true
            destVC.service = statsService
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let gameVC = storyBoard.instantiateViewController(withIdentifier: "GameVC") as? GameVC {
            let category = SentenceCategory.allCases[indexPath.row]
            gameVC.category = category
            gameVC.hidesBottomBarWhenPushed = true
            gameVC.service = statsService
            self.navigationController?.pushViewController(gameVC, animated: true)
        }
    }
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == self.tableView, scrollView.contentOffset.y <= 0 {
//            scrollView.contentOffset = CGPoint(x: 0, y: 0)
//        }
//    }

}
