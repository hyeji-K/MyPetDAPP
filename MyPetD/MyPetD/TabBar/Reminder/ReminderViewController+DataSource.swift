//
//  ReminderViewController+DataSource.swift
//  MyPetD
//
//  Created by heyji on 2022/10/15.
//

import UIKit

extension ReminderViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        if snapshot.itemIdentifiers.isEmpty {
            collectionView.setEmptyView(title: "일정을 추가해보세요", message: "+ 버튼을 클릭하여 일정을 추가할 수 있습니다.")
        } else {
            collectionView.restore()
        }
        dataSource.apply(snapshot)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(for: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        let stringToDate = reminder.dueDate.dateLong!
        contentConfiguration.secondaryText = "\(stringToDate.dayAndTimeText), \(reminder.repeatCycle)"
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .callout)
        
        if reminder.dueDate.dateLong!.stringFormatShort == Date.now.stringFormatShort {
            contentConfiguration.secondaryTextProperties.color = .appleBlossomColor
        } else {
            contentConfiguration.secondaryTextProperties.color = .lightGray
        }
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .fiordColor
        cell.accessories = [.customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .white
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(for: id)
        if reminder.isComplete == false {
            switch reminder.repeatCycle {
            case RepectCycle.none.name:
                reminder.isComplete.toggle()
                update(reminder, with: id)
                updateSnapshot(reloading: [id])
                
                NetworkService.shared.updateCompleteReminder(id: reminder.id, reminder: reminder, classification: .completeReminder)
                
                deleteReminder(with: id)
                updateSnapshot()
            
            case RepectCycle.everyDay.name:
                completeReminderHandler(with: id, for: RepectCycle.everyDay)
                
            case RepectCycle.everyWeek.name:
                completeReminderHandler(with: id, for: RepectCycle.everyWeek)
                
            case RepectCycle.everyMonth.name:
                completeReminderHandler(with: id, for: RepectCycle.everyMonth)
                
            case RepectCycle.everyYear.name:
                completeReminderHandler(with: id, for: RepectCycle.everyYear)
                
            default:
                print()
            }
        } else {
            // 완료 해제시
        }
    }
    
    private func completeReminderHandler(with id: Reminder.ID, for repectCycle: RepectCycle) {
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        
        NetworkService.shared.updateCompleteReminder(id: reminder.id, reminder: reminder, classification: .completeReminder)
        
        self.update(reminder, with: id)
        self.updateSnapshot(reloading: [id])
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let date = reminder.dueDate.dateLong!
            let changeDate = Calendar.current.date(byAdding: repectCycle.adding, value: repectCycle.repeatValue, to: date)!.stringFormat
            reminder.dueDate = changeDate
            reminder.isComplete.toggle()
            self.update(reminder, with: id)
            self.updateSnapshot(reloading: [id])
        }
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "checkmark.circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    func add(_ reminder: Reminder) {
//        reminders.append(reminder)
//        let date = reminder.dueDate.dateLong!.stringFormat
//        let object = Reminder(id: reminder.id, title: reminder.title, dueDate: "\(date)", repeatCycle: reminder.repeatCycle, isComplete: reminder.isComplete)
//        self.ref.child("Reminder").child(reminder.id).setValue(object.toDictionary)
    }
    
    func deleteReminder(with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders.remove(at: index)
        
        NetworkService.shared.deleteData(with: id, classification: .reminder)
    }
    
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    func update(_ reminder: Reminder, with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
        NetworkService.shared.updateReminder(reminder: reminder, classification: .reminder)
    }
}
