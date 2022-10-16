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
            
            let settingsConfig = CustomBarItemConfiguration(image: UIImage(systemName: "gearshape")) {
                print("setting button tapped")
                let settingViewController = SettingViewController()
                self.navigationController?.pushViewController(settingViewController, animated: true)
            }
            let settingsItem = UIBarButtonItem.generate(with: settingsConfig, width: 30)
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
            navigationItem.rightBarButtonItems = [settingsItem, addItem]
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
            
        case is ReminderViewController:
            let titleConfig = CustomBarItemConfiguration(title: "ReminderView", action: { print("title tapped") })
            let titleItem = UIBarButtonItem.generate(with: titleConfig)
            navigationItem.leftBarButtonItem = titleItem
            
            let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
                print("plus button tapped")
                let reminder = Reminder(title: "", dueDate: Date.now, repeatCycle: "반복없음")
                let viewController = ReminderDetailViewController(reminder: reminder) { reminder in
//                    let reminderView = ReminderViewController()
//                    reminderView.add(reminder)
//                    reminderView.updateSnapshot()
//                    self.dismiss(animated: true, completion: nil)
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
