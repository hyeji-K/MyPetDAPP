//
//  CompletedReminder.swift
//  MyPetD
//
//  Created by heyji on 2022/12/13.
//

import Foundation

class CompletedReminderManager {
    var completeReminderDic: [String: [Reminder]] = [:]
    var sortedReminderTuple: [(String, [Reminder])] = []
    var sectionHeaderTitles: [String] = []
    var completeReminders: [[Reminder]] = []
    
    func deleteReminder(indexPath: IndexPath) {
        let completeDate = self.sectionHeaderTitles[indexPath.section]
        let reminderId = self.completeReminders[indexPath.section][indexPath.row].id
        
        NetworkService.shared.deleteData(with: reminderId, date: completeDate, classification: .completeReminder)
    }
}
