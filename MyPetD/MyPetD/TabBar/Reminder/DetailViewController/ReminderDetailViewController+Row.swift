//
//  ReminderDetailViewController+Row.swift
//  MyPetD
//
//  Created by heyji on 2022/10/15.
//

import UIKit

extension ReminderDetailViewController {
    enum Row: Hashable {
        case header(String)
        case viewTitle
        case viewDate
        case viewTime
        case viewRepeat
        case editText(String?)
        case editDate(Date)
        
        var imageName: String? {
            switch self {
//            case .viewTitle: return "checkmark.circle.fill"
            case .viewDate: return "calendar.circle"
            case .viewTime: return "clock"
            case .viewRepeat: return "repeat.circle"
            default: return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .viewTitle: return .headline
            default: return .body
            }
        }
    }
}
