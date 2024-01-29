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
                return NSLocalizedString("할 일", comment: "Title section name")
            case .dateAndTime:
                return NSLocalizedString("날짜와 시간", comment: "Date and Time section name")
            case .repeatCycle:
                return NSLocalizedString("반복 주기", comment: "RepeatCycle section name")
            }
        }
    }
}
