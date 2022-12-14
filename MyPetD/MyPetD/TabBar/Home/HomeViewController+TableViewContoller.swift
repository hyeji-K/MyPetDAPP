//
//  HomeViewController+TableViewContoller.swift
//  MyPetD
//
//  Created by heyji on 2022/10/19.
//

import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if toggleTableView == false {
            return self.productManager.products.count
        } else {
            return todayReminders.count + todayIsCompletedReminders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if toggleTableView == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellId, for: indexPath) as! ProductCell
            cell.selectionStyle = .none
            cell.configure(self.productManager.products[indexPath.row])
            
            return cell
        } else {
            self.reminderMamager.reminders = self.todayReminders + self.todayIsCompletedReminders
            let reminder = self.reminderMamager.reminders[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.selectionStyle = .none
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            contentConfiguration.textProperties.font = UIFont.boldSystemFont(ofSize: 14)
            let stringToDate = reminder.dueDate.dateLong!
            contentConfiguration.secondaryText = "\(stringToDate.dayAndTimeText), \(reminder.repeatCycle)"
            contentConfiguration.secondaryTextProperties.font = UIFont.systemFont(ofSize: 13)
            contentConfiguration.secondaryTextProperties.color = .systemGray
            let symbolName = reminder.isComplete ? "checkmark.circle.fill" : "circle"
            let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
            let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
            contentConfiguration.imageProperties.tintColor = .ebonyClayColor
            contentConfiguration.image = image
            cell.contentConfiguration = contentConfiguration
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if toggleTableView == false {
            self.tabBarController?.selectedIndex = 1
        } else {
            self.tabBarController?.selectedIndex = 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if toggleTableView == false {
            return 75
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white

        headerView.addSubview(productButton)
        productButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(headerView.snp.width).dividedBy(2)
            make.height.equalTo(42)
        }
        productButton.addTarget(self, action: #selector(productButtonTapped), for: .touchUpInside)
        
        headerView.addSubview(todoButton)
        todoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(headerView.snp.width).dividedBy(2)
            make.height.equalTo(42)
        }
        todoButton.addTarget(self, action: #selector(todoButtonTapped), for: .touchUpInside)
        
        let seperatedView = UIView()
        seperatedView.backgroundColor = .lightGray
        headerView.addSubview(seperatedView)
        seperatedView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.8)
            make.width.equalToSuperview()
        }
        
        headerView.addSubview(selectProductView)
        selectProductView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview().dividedBy(2)
            make.height.equalTo(4)
            make.width.equalTo(productButton.snp.width).dividedBy(2)
        }
        
        headerView.addSubview(selectTodoView)
        selectTodoView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(50)
            make.height.equalTo(4)
            make.width.equalTo(todoButton.snp.width).dividedBy(2)
        }
        
        return headerView
    }
}
