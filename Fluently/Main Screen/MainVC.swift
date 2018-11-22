//
//  MainVC.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 21/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {
    
    private let titleHeight:CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = GlobalConstants.Color.havelockBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tableView.contentInset = UIEdgeInsets(top: -120, left: 0, bottom: 0, right: 0)
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
