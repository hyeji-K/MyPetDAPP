//
//  ReminderDetailViewController+CellConfiguration.swift
//  MyPetD
//
//  Created by heyji on 2022/10/15.
//

import UIKit

extension ReminderDetailViewController {
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        contentConfiguration.imageProperties.tintColor = .fiordColor
        return contentConfiguration
    }
    
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
        contentConfiguration.textProperties.color = .black
        return contentConfiguration
    }
    
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        contentConfiguration.onChange = { [weak self] title in
            self?.workingReminder.title = title
        }
        return contentConfiguration
    }
    
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DateAndTimePickerContentView.Configuration {
        var contentConfiguration = cell.dateAndTimePickerConfiguration()
        contentConfiguration.date = date
        contentConfiguration.onChange = { [weak self] dueDate in
            self?.workingReminder.dueDate = dueDate
        }
        return contentConfiguration
    }
    
    func repeatConfiguration(for cell: UICollectionViewListCell, with repeatCycle: String?) -> CollectionContentView.Configuration {
        var contentConfiguration = cell.collectionViewConfiguration()
        contentConfiguration.repeatCycle = repeatCycle
        contentConfiguration.onChange = { [weak self] repeatCycle in
            self?.workingReminder.repeatCycle = repeatCycle
        }
        return contentConfiguration
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .viewTitle: return reminder.title
        case .viewDate: return reminder.dueDate.dateLong!.dayText
        case .viewTime: return reminder.dueDate.dateLong!.timeText
        case .viewRepeat: return reminder.repeatCycle
        default: return nil
        }
    }
}
