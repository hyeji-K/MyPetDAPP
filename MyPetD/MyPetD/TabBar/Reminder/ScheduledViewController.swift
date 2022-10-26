//
//  ScheduledViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/10/16.
//

import UIKit
import FirebaseDatabase

class ScheduledViewController: UIViewController {
    
    var sectionHeaderTitles: [String] = []
    var completeReminder: [String: [Reminder]] = [:]
    var sortedReminderTuple: [(String, [Reminder])] = []
    
    var tableView = UITableView()
    
    var ref: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        fetch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            if !self.sectionHeaderTitles.isEmpty {
                let section = self.sectionHeaderTitles.count - 1
                let row = self.sortedReminderTuple[section].1.endIndex - 1
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
    
    func fetch() {
        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        self.ref.child("CompleteReminder").observe(.value) { snapshot in
            guard let snapshot = snapshot.value as? [String: Any] else { return }
            self.sectionHeaderTitles = snapshot.keys.map({ $0 }).sorted(by: { $0 < $1 })
            
            guard let snapshotValue = Array(snapshot.values) as? [[String: Any]] else { return }
            for value in snapshotValue {
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(value.values), options: [])
                    let decoder = JSONDecoder()
                    let reminders: [Reminder] = try decoder.decode([Reminder].self, from: data)
                    let date = reminders[0].dueDate.dateLong!.stringFormatShortline
                    
                    for headerTitle in self.sectionHeaderTitles {
                        if headerTitle == date {
                            self.completeReminder.updateValue(reminders, forKey: headerTitle)
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            self.sortedReminderTuple = self.completeReminder.sorted { $0.key < $1.key }
            self.tableView.reloadData()
        }
    }
    
    func deleteReminder(indexPath: IndexPath) {
        let completeDate = self.sectionHeaderTitles[indexPath.section]
        let reminderId = self.sortedReminderTuple[indexPath.section].1[indexPath.row].id
        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        self.ref.child("CompleteReminder").child(completeDate).child(reminderId).removeValue()
    }
}

extension ScheduledViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedReminderTuple[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        let symbolName = sortedReminderTuple[indexPath.section].1[indexPath.row].isComplete ? "checkmark.circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        contentConfiguration.image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        contentConfiguration.imageProperties.tintColor = .ebonyClayColor
        
        contentConfiguration.text = sortedReminderTuple[indexPath.section].1[indexPath.row].title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        contentConfiguration.secondaryText = "\(sortedReminderTuple[indexPath.section].1[indexPath.row].dueDate.dateLong!.timeText), \(sortedReminderTuple[indexPath.section].1[indexPath.row].repeatCycle)"
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
        titleLabel.text = sectionHeaderTitles[section].date!.dayText // EX, 10월 21일 금요일
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
            self.deleteReminder(indexPath: indexPath)
        }
    }
}
