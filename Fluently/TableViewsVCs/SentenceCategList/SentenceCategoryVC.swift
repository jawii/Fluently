//
//  SentenceCategoryVC.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 25/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class SentenceCategoryVC: UITableViewController {
    
    var service: StatsService!
    var statistics: StatsValues!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statistics = StatsValues(service: service)
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SentenceCategory.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentenceCategoryTableCell", for: indexPath) as? SentenceCategoryTableCell else {
            return UITableViewCell()
        }
        let category = SentenceCategory.allCases[indexPath.row]
        let wordCount = statistics.wordsForCategory(category)
        
        cell.setupCellForCategory(category, wordCount: wordCount)
        cell.delegate = self
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

}

extension SentenceCategoryVC: SentenceCategoryTableViewCellDelegate {
    func didTapButtonFor(category: SentenceCategory) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let gameVC = storyBoard.instantiateViewController(withIdentifier: "GameVC") as? GameVC {
            gameVC.category = category
            gameVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(gameVC, animated: true)
        }
    }
}
