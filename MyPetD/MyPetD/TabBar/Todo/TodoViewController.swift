//
//  TodoViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/27.
//

import UIKit

final class TodoViewController: UIViewController {
    
    private let calenderView: CalenderView = CalenderView()
    private let todoView: TodoView = TodoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.view.backgroundColor = .white
        
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.calenderCollecionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupView() {
        self.view.addSubview(calenderView)
        calenderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        self.view.addSubview(todoView)
        todoView.snp.makeConstraints { make in
            make.top.equalTo(calenderView.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        todoView.todoTableView.separatorStyle = .none
        todoView.todoTableView.delegate = self
    }
}

extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoViewController = EditTodoViewController()
        self.present(todoViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        var titleLabel = UILabel()
        titleLabel.text = "일정"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        headerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        for i in 0..<6 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Ellipse\(i)")
            imageView.tintColor = .systemOrange
            stackView.addArrangedSubview(imageView)
        }
        
        let seperatedView = UIView()
        seperatedView.backgroundColor = .black
        headerView.addSubview(seperatedView)
        seperatedView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        return headerView
    }
    
}
