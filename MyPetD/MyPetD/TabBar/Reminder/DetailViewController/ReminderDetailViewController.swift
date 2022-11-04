//
//  ReminderDetailViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/10/15.
//

import UIKit

class ReminderDetailViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder {
        didSet {
            onChange(reminder)
        }
    }
    var workingReminder: Reminder
    var isAddingNewReminder = false
    var onChange: (Reminder) -> Void
    private var dataSource: DataSource!
    
    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        listConfiguration.backgroundColor = .white
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        navigationItem.title = NSLocalizedString("상세한 일정", comment: "Reminder detail view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem!.title = "편집"
        
        updateSnapshotForViewing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.editButtonItem.title = editing ? "저장" : "편집"
        if editing {
            prepareForEditing()
        } else {
            if !isAddingNewReminder {
                prepareForViewing()
            } else {
                onChange(workingReminder)
                
                NetworkService.shared.updateReminder(reminder: workingReminder, classification: .reminder)
            }
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
            cell.layer.borderWidth = 0
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
            cell.isHighlighted = false
            cell.isSelected = false
            var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfiguration.backgroundColor = .white
            cell.backgroundConfiguration = backgroundConfiguration
        case (.title, .editText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor.shadyLadyColor.cgColor
        case (.dateAndTime, .editDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor.shadyLadyColor.cgColor
        case (.repeatCycle, .editText(let repeatCycle)):
            cell.contentConfiguration = repeatConfiguration(for: cell, with: repeatCycle)
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor.shadyLadyColor.cgColor
        default:
            fatalError("Unexpected combination of section and row.")
        }
        
        cell.tintColor = .tintColor
    }
    
    @objc func didCancelEdit() {
        workingReminder = reminder
        setEditing(false, animated: true)
    }
    
    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .dateAndTime, .repeatCycle])
        snapshot.appendItems([.header(Section.title.name), .editText(reminder.title)], toSection: .title)
        let date = reminder.dueDate.dateLong
        snapshot.appendItems([.header(Section.dateAndTime.name), .editDate(date!)], toSection: .dateAndTime)
        snapshot.appendItems([.header(Section.repeatCycle.name), .editText(reminder.repeatCycle)], toSection: .repeatCycle)
        dataSource.apply(snapshot)
    }
    
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingReminder != reminder {
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }
    
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([.header(""), .viewTitle, .viewDate, .viewTime, .viewRepeat], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}
