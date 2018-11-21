//
//  MainVC.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 21/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = GlobalConstants.Color.havelockBlue
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 120)
        return TitleView(frame: rect)
    }
    
}
