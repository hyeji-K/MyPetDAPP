//
//  ScheduledViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/10/16.
//

import UIKit

class ScheduledViewController: UIViewController {
    private var completedReminderManager = CompletedReminderManager()
    private var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            if !self.completedReminderManager.sectionHeaderTitles.isEmpty {
                let section = self.completedReminderManager.sectionHeaderTitles.count - 1
                let row = self.completedReminderManager.sortedReminderTuple[section].1.endIndex - 1
                let endIndex = IndexPath(row: row, section: section)
                self.tableView.scrollToRow(at: endIndex, at: .top, animated: true)
            }
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "완료한 일정"
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.sectionHeaderTopPadding = .zero
        tableView.backgroundView = .none
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func fetch() {
        NetworkService.shared.getDataList(classification: .completeReminder) { snapshot in
            if snapshot.exists() {
                self.completedReminderManager.sortedReminderTuple = []
                self.completedReminderManager.sectionHeaderTitles = []
                self.completedReminderManager.completeReminderDic = [:]
                self.completedReminderManager.completeReminders = []
                
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                self.completedReminderManager.sectionHeaderTitles = snapshot.keys.map({ $0 }).sorted(by: { $0 < $1 })
                
                guard let snapshotValue = Array(snapshot.values) as? [[String: Any]] else { return }
                for value in snapshotValue {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: Array(value.values), options: [])
                        let decoder = JSONDecoder()
                        let reminders: [Reminder] = try decoder.decode([Reminder].self, from: data)
                        let date = reminders[0].dueDate.dateLong!.stringFormatShortline
                        
                        for headerTitle in self.completedReminderManager.sectionHeaderTitles {
                            if headerTitle == date {
                                self.completedReminderManager.completeReminderDic.updateValue(reminders, forKey: headerTitle)
                            }
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                
                self.completedReminderManager.sortedReminderTuple = self.completedReminderManager.completeReminderDic.sorted { $0.key < $1.key }
                
                for (_, value) in self.completedReminderManager.sortedReminderTuple {
                    self.completedReminderManager.completeReminders.append(value)
                }
                
                self.tableView.reloadData()
            } else {
                self.completedReminderManager.sortedReminderTuple = []
                self.completedReminderManager.sectionHeaderTitles = []
                self.completedReminderManager.completeReminderDic = [:]
                self.completedReminderManager.completeReminders = []
                self.tableView.setEmptyView(title: "완료한 일정이 없습니다", message: "")
            }
        }
    }
}

extension ScheduledViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.completedReminderManager.sectionHeaderTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completedReminderManager.completeReminders[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        
        let symbolName = self.completedReminderManager.completeReminders[indexPath.section][indexPath.row].isComplete ? "checkmark.circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        contentConfiguration.image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        contentConfiguration.imageProperties.tintColor = .fiordColor
        
        contentConfiguration.text = self.completedReminderManager.completeReminders[indexPath.section][indexPath.row].title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        
        contentConfiguration.secondaryText = "\(self.completedReminderManager.completeReminders[indexPath.section][indexPath.row].dueDate.dateLong!.timeText), \(self.completedReminderManager.completeReminders[indexPath.section][indexPath.row].repeatCycle)"
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .callout)
        contentConfiguration.secondaryTextProperties.color = .lightGray
        cell.contentConfiguration = contentConfiguration
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.text = self.completedReminderManager.sectionHeaderTitles[section].date!.dayText
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .systemGray6
        return footerView
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.completedReminderManager.deleteReminder(indexPath: indexPath)
            
            if self.completedReminderManager.completeReminders[indexPath.section].count <= 1 {
                self.completedReminderManager.sectionHeaderTitles.remove(at: indexPath.section)
                self.completedReminderManager.completeReminders.remove(at: indexPath.section)
            } else {
                self.completedReminderManager.completeReminders[indexPath.section].remove(at: indexPath.row)
            }
            
//            let indexSet = IndexSet(arrayLiteral: indexPath.section)
//            tableView.deleteSections(indexSet, with: .fade)
            self.tableView.reloadData()
        }
    }
}
