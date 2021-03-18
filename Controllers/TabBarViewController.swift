//
//  TabBarViewController.swift
//  WhatsApps
//
//  Created by Usama on 01/03/2021.
//

import UIKit

//MARK:- Base Methods
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationController?.navigationBar.isHidden = false
    }

}
