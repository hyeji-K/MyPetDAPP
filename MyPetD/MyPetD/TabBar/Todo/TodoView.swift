//
//  TodoView.swift
//  MyPetD
//
//  Created by heyji on 2022/09/02.
//

import UIKit

final class TodoView: UIView, UITableViewDataSource {
    
    var todoTableView = UITableView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        todoTableView.dataSource = self
        todoTableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.cellId)
        todoTableView.showsVerticalScrollIndicator = false
        todoTableView.sectionHeaderTopPadding = .zero
        todoTableView.separatorStyle = .none
        addSubview(todoTableView)
        todoTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.cellId, for: indexPath) as? TodoCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            tableView.deleteRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
        }
    }
}


