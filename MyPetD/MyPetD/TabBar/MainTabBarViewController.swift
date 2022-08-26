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
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.title = "LargeTitles"
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
                let addItemViewController = AddItemViewController()
                addItemViewController.modalTransitionStyle = .crossDissolve
                addItemViewController.modalPresentationStyle = .overFullScreen
                self.present(addItemViewController, animated: true, completion: nil)
                
//                let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//                alert.modalPresentationStyle = .overFullScreen
//                let action1 = UIAlertAction(title: "나의 반려동물 추가하기", style: .default, handler: nil)
//                alert.addAction(action1)
//
//                let action2 = UIAlertAction(title: "제품 추가하기", style: .default, handler: nil)
//                alert.addAction(action2)
//
//                let action3 = UIAlertAction(title: "일정 추가하기", style: .default, handler: nil)
//                alert.addAction(action3)
//
//                let action4 = UIAlertAction(title: "취소", style: .destructive)
//                alert.addAction(action4)
//                self.present(alert, animated: true, completion: nil)
            }
            let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
            navigationItem.rightBarButtonItems = [addItem, notificationItem]
            navigationItem.backButtonDisplayMode = .minimal
            
        case is BoxViewController:
            let titleConfig = CustomBarItemConfiguration(title: "BoxView", action: { print("title tapped") })
            let titleItem = UIBarButtonItem.generate(with: titleConfig)
            navigationItem.leftBarButtonItem = titleItem
            
            let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
                print("plus button tapped")
                let addProductViewController = AddProductViewController()
                self.present(addProductViewController, animated: true, completion: nil)
            }
            let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
            navigationItem.rightBarButtonItems = [addItem]
            navigationItem.backButtonDisplayMode = .minimal
            
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
