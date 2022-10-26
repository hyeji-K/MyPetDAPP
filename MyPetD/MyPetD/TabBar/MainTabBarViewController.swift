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
            let titleConfig = CustomBarItemConfiguration(title: "AppName", action: { print("title tapped") })
            let titleItem = UIBarButtonItem.generate(with: titleConfig)
            navigationItem.leftBarButtonItem = titleItem
            
            let settingsConfig = CustomBarItemConfiguration(image: UIImage(systemName: "gearshape")) {
                let settingViewController = SettingViewController()
                self.navigationController?.pushViewController(settingViewController, animated: true)
            }
            let settingsItem = UIBarButtonItem.generate(with: settingsConfig, width: 30)
            let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
                let today = Date.now.stringFormat
                let petInfo = PetInfo(image: "", name: "", birthDate: today, withDate: today)
                let viewController = PetViewController(petInfo) { petInfo in
                }
                viewController.navigationItem.title = NSLocalizedString("반려동물 추가하기", comment: "Add Pet view controller title")
                
                viewController.isAddingNewPetInfo = true
                let navigationContoller = UINavigationController(rootViewController: viewController)
                navigationContoller.navigationBar.tintColor = .black
                
                self.present(navigationContoller, animated: true, completion: nil)
            }
            let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
            navigationItem.rightBarButtonItems = [settingsItem, addItem]
            navigationItem.backButtonDisplayMode = .minimal
            
        case is BoxViewController:
            let titleConfig = CustomBarItemConfiguration(title: "간식창고", action: { print("title tapped") })
            let titleItem = UIBarButtonItem.generate(with: titleConfig)
            navigationItem.leftBarButtonItem = titleItem
            
            let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
                print("plus button tapped")
                let today = Date.now.stringFormat
                let productInfo = ProductInfo(image: "", name: "", expirationDate: today, storedMethod: "", memo: "")
                let viewController = ProductViewController(product: productInfo) { [weak self] productInfo in
                }
                viewController.isAddingNewProduct = true
                viewController.setEditing(true, animated: false)
                viewController.navigationItem.title = NSLocalizedString("상품 추가하기", comment: "Add Product view controller title")
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.navigationBar.tintColor = .black
                self.present(navigationController, animated: true)
            }
            let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
            navigationItem.rightBarButtonItems = [addItem]
            navigationItem.backButtonDisplayMode = .minimal
            
        case is ReminderViewController:
            let titleConfig = CustomBarItemConfiguration(title: "ReminderView", action: { print("title tapped") })
            let titleItem = UIBarButtonItem.generate(with: titleConfig)
            navigationItem.leftBarButtonItem = titleItem
            
            let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
                print("plus button tapped")
                let today = Date.now.stringFormat
                let reminder = Reminder(title: "", dueDate: today, repeatCycle: "반복없음")
                let viewController = ReminderDetailViewController(reminder: reminder) { reminder in
                    print("add 에서 넘어왔어여 \(reminder)")
//                    self.add(reminder)
//                    self.updateSnapshot()
                    self.dismiss(animated: true, completion: nil)
                }
                viewController.isAddingNewReminder = true
                viewController.setEditing(true, animated: false)
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.didCancelAdd))
                viewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            }
            let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
            
            let scheduledConfig = CustomBarItemConfiguration(image: UIImage(systemName: "checklist")) {
                print("schedule button tapped")
                let viewController = ScheduledViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            let scheduledItem = UIBarButtonItem.generate(with: scheduledConfig, width: 30)
            
//            let addItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(ReminderViewController().didPressAddButton(_:)))
            navigationItem.rightBarButtonItems = [scheduledItem, addItem]
            navigationItem.backButtonDisplayMode = .minimal
             
//        case is TodoViewController:
//            let titleConfig = CustomBarItemConfiguration(title: "TodoView", action: { print("title tapped") })
//            let titleItem = UIBarButtonItem.generate(with: titleConfig)
//            navigationItem.leftBarButtonItem = titleItem
//
//            let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
//                print("plus button tapped")
//                let addTodoViewController = AddTodoViewController()
//                self.present(addTodoViewController, animated: true, completion: nil)
//            }
//            let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
//            navigationItem.rightBarButtonItems = [addItem]
//            navigationItem.backButtonDisplayMode = .minimal
            
        default:
            break
        }
    }
    @objc func didCancelAdd() {
        dismiss(animated: true)
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateNavigationItem(viewController: viewController)
    }
}
