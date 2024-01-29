//
//  MainTabBarViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPage(_:)), name: Notification.Name("showPage"), object: nil)
        
        UITabBar.appearance().tintColor = .fiordColor
    }
    
    @objc func showPage(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let index = userInfo["index"] as? Int {
                self.selectedIndex = index
            }
        }
    }
}
