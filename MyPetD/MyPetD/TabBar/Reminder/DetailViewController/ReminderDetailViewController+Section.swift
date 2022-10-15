//
//  ReminderDetailViewController+Section.swift
//  MyPetD
//
//  Created by heyji on 2022/10/15.
//

import Foundation

extension ReminderDetailViewController {
    enum Section: Int, Hashable {
        case view
        case title
        case dateAndTime
        case repeatCycle
        
        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
            case .dateAndTime:
                return NSLocalizedString("Date and Time", comment: "Date and Time section name")
            case .repeatCycle:
                return NSLocalizedString("Repeat Cycle", comment: "RepeatCycle section name")
            }
        }
    }
}
