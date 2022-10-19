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
            return productInfo.count
        } else {
            return reminders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if toggleTableView == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellId, for: indexPath) as! ProductCell
            cell.selectionStyle = .none
            cell.configure(productInfo[indexPath.row])
            
            return cell
        } else {
            let reminder = self.reminders[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.selectionStyle = .none
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            let stringToDate = reminder.dueDate.dateLong!
            contentConfiguration.secondaryText = "\(stringToDate.dayAndTimeText), \(reminder.repeatCycle)"
            contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
            let symbolName = reminder.isComplete ? "checkmark.circle.fill" : "circle"
            let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
            let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
            contentConfiguration.imageProperties.tintColor = .systemGray
            contentConfiguration.image = image
            cell.contentConfiguration = contentConfiguration
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if toggleTableView == false {
            return 95
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
//        headerView.layer.cornerRadius = 10
//        headerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
//        headerView.layer.borderWidth = 1
//        headerView.layer.borderColor = UIColor.systemGray3.cgColor

        let productButton = UIButton()
        productButton.setTitle("임박 제품", for: .normal)
        productButton.setTitleColor(.black, for: .normal)
        productButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        headerView.addSubview(productButton)
        productButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(headerView.snp.width).dividedBy(2)
            make.height.equalTo(43)
        }
        productButton.addTarget(self, action: #selector(productButtonTapped), for: .touchUpInside)
        
        let todoButton = UIButton()
        todoButton.setTitle("오늘 일정", for: .normal)
        todoButton.setTitleColor(.black, for: .normal)
        todoButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        headerView.addSubview(todoButton)
        todoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(headerView.snp.width).dividedBy(2)
            make.height.equalTo(43)
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
//            make.left.equalToSuperview().inset(50)
            make.centerX.equalToSuperview().dividedBy(2)
            make.height.equalTo(3)
            make.width.equalTo(productButton.snp.width).dividedBy(2)
        }
        
        headerView.addSubview(selectTodoView)
        selectTodoView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(50)
//            make.centerX.equalTo(todoButton.snp.view.widthAnchor)
            make.height.equalTo(3)
            make.width.equalTo(todoButton.snp.width).dividedBy(2)
        }
        
        return headerView
    }
}
