//
//  OpenSourceTableViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/11/08.
//

import UIKit

class OpenSourceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let openSourceData: [OpenSource] = OpenSource.data

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OpenSourceCell")
        tableView.delegate = self
        tableView.dataSource = self

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openSourceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenSourceCell", for: indexPath)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = openSourceData[indexPath.row].title
        
        contentConfiguration.secondaryText = openSourceData[indexPath.row].description
        
        cell.contentConfiguration = contentConfiguration

        return cell
    }
}
