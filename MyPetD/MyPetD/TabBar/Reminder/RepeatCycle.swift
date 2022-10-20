//
//  RepeatCycle.swift
//  MyPetD
//
//  Created by heyji on 2022/10/20.
//

import UIKit

extension ReminderViewController {
    enum RepectCycle {
        case none
        case everyDay
        case everyWeek
        case everyMonth
        case everyYear
        
        var name: String {
            switch self {
            case .none:
                return "반복없음"
            case .everyDay:
                return "매일"
            case .everyWeek:
                return "매주"
            case .everyMonth:
                return "매월"
            case .everyYear:
                return "매년"
            }
        }
        
        var adding: Calendar.Component {
            switch self {
            case .none:
                return .minute
            case .everyDay:
                return .day
            case .everyWeek:
                return .day
            case .everyMonth:
                return .month
            case .everyYear:
                return .year
            }
        }
        
        var repeatValue: Int {
            switch self {
            case .none:
                return 0
            case .everyDay:
                return 1
            case .everyWeek:
                return 7
            case .everyMonth:
                return 1
            case .everyYear:
                return 1
            }
        }
    }
}
