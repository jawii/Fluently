//
//  LanguageListVC.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 24/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class LanguageListVC: UIViewController {
    
    // MARK:- Properties
    var service: StatsService!
    var statistics: StatsValues!

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Change Learning Language", comment: "")
        
        tableview.delegate = self
        tableview.dataSource = self
        
        statistics = StatsValues(service: service)
        
        tableview.reloadData()
        
        
        tableview.estimatedRowHeight = 150
        tableview.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear

    }

}

extension LanguageListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LearningLanguage.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LangTableViewCell", for: indexPath) as? LangTableViewCell else { return UITableViewCell() }
        
        let language = LearningLanguage.allCases[indexPath.row]
        let stats = statistics.getStatsForLang(language)
        
        cell.configureCell(forLanguage: language, stats: stats)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

extension LanguageListVC: LanguageCellDelegate {
    func appLanguageDidSet() {
        // go trough tableview cells and deselect languages
        var indexPaths = [IndexPath]()
        for i in  0 ... LearningLanguage.allCases.count - 1{
            let indexPath = IndexPath(row: i, section: 0)
            indexPaths.append(indexPath)
        }        
        indexPaths.forEach { ip in
            if let cell = tableview.cellForRow(at: ip) as? LangTableViewCell {
                if cell.language != LanguageService.shared.learningLanguage {
                    cell.deselect()
                }
            }
        }
 
    }
    
    
}
