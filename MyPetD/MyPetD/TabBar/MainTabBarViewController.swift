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
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateNavigationItem(viewController: self.selectedViewController!)
    }
    
    private func updateNavigationItem(viewController: UIViewController) {
        switch viewController {
        case is HomeViewController:
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "LargeTitles"
//            let image = UIImage(systemName: "sun.max")
//            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//            navigationController?.navigationBar.backgroundColor = .clear
//            navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "sun.max.fill")
            
            // customBarItem
            let titleConfig = CustomBarItemConfiguration(title: "HomeView", action: { print("title tapped") })
            let titleItem = UIBarButtonItem.generate(with: titleConfig)
            navigationItem.leftBarButtonItem = titleItem
            
            let notificationConfig = CustomBarItemConfiguration(image: UIImage(systemName: "bell")) {
                print("bell button tapped")
            }
            let notificationItem = UIBarButtonItem.generate(with: notificationConfig, width: 30)
            let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
                print("plus button tapped")
            }
            let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
            navigationItem.rightBarButtonItems = [addItem, notificationItem]
            
            
        default:
            print("")
        }
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateNavigationItem(viewController: viewController)
    }
}
