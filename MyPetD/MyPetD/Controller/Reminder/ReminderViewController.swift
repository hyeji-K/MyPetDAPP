//
//  ReminderViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/10/14.
//

import UIKit

final class ReminderViewController: UICollectionViewController {
        
    var dataSource: DataSource!
    var reminderManager = ReminderManager()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = listLayout()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        setupNavigationBar()
        fetch()
        updateSnapshot()
        collectionView.dataSource = dataSource
        initRefresh()
    }
    
    private func setupNavigationBar() {
        let titleConfig = CustomBarItemConfiguration(title: "전체 일정", action: { print("title tapped") })
        let titleItem = UIBarButtonItem.generate(with: titleConfig)
        navigationItem.leftBarButtonItem = titleItem
        
        let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
            let reminder = self.reminderManager.createReminder()
            let viewController = ReminderDetailViewController(reminder: reminder) { [weak self] reminder in
                self?.dismiss(animated: true, completion: nil)
                self?.reminderManager.addReminder(reminder)
            }
            viewController.isAddingNewReminder = true
            viewController.setEditing(true, animated: false)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.didCancelAdd))
            viewController.navigationItem.title = NSLocalizedString("일정 추가하기", comment: "Add Reminder view controller title")
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.tintColor = .black
            self.present(navigationController, animated: true, completion: nil)
        }
        let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
        
        let scheduledConfig = CustomBarItemConfiguration(image: UIImage(systemName: "checklist")) {
            let viewController = ScheduledViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        let scheduledItem = UIBarButtonItem.generate(with: scheduledConfig, width: 30)
        
        navigationItem.rightBarButtonItems = [scheduledItem, addItem]
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func fetch() {
        NetworkService.shared.getDataList(classification: .reminder) { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let reminders: [Reminder] = try decoder.decode([Reminder].self, from: data)
                    
                    self.reminderManager.reminders = reminders.sorted(by: { $0.dueDate < $1.dueDate })
                    self.updateSnapshot()
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                // 스냅샷이 존재하지 않을때
                self.reminderManager.reminders = []
                self.updateSnapshot()
            }
        }
    }
    
    private func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        refreshControl.tintColor = .fiordColor
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshCollectionView(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.collectionView.reloadData()
            refresh.endRefreshing()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminderManager.reminders[indexPath.item].id
        showDetail(for: id)
        return false
    }
    
    private func showDetail(for id: Reminder.ID) {
        let reminder = self.reminderManager.reminder(for: id)
        let viewController = ReminderDetailViewController(reminder: reminder, onChange: { [weak self] reminder in
            self?.reminderManager.updateReminder(reminder, with: reminder.id)
            self?.updateSnapshot(reloading: [reminder.id])
        })
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions(for:)
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("삭제", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.reminderManager.deleteReminder(with: id)
            self?.updateSnapshot()
            LocalNotifications.shared.removeNotification(id: id)
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
