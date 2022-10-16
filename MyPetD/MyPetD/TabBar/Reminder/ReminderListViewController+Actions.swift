//
//  ReminderListViewController+Actions.swift
//  MyPetD
//
//  Created by heyji on 2022/10/15.
//

import UIKit

extension ReminderViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
        print("press \(id)")
    }
    
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let today = Date.now.stringFormat
        let reminder = Reminder(title: "", dueDate: today, repeatCycle: "반복없음")
        let viewController = ReminderDetailViewController(reminder: reminder) { [weak self] reminder in
            self?.add(reminder)
            self?.updateSnapshot()
            self?.dismiss(animated: true, completion: nil)
        }
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: false)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
