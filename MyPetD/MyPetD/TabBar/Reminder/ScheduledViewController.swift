//
//  ScheduledViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/10/16.
//

import UIKit

class ScheduledViewController: UIViewController {
    
    let reminders: [Reminder] = Reminder.sampleData
    let sectionHeaderTitles: [String] = ["Today", "Monday, Oct 17", "Tuesday, Oct 18", "Wednesday, Oct 19", "Thursday, Oct 20", "Friday, Oct 21"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.title = "완료한 일정"
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.separatorInset = .zero
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
}

extension ScheduledViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return reminders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.image = UIImage(systemName: "checkmark.circle.fill")
        contentConfiguration.imageProperties.tintColor = .systemYellow
        contentConfiguration.text = reminders[indexPath.item].title
        contentConfiguration.secondaryText = reminders[indexPath.item].dueDate.timeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return reminders
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = sectionHeaderTitles[section]
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
    
}
