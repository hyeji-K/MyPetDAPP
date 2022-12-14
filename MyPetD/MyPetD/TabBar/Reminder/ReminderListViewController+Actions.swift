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
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
