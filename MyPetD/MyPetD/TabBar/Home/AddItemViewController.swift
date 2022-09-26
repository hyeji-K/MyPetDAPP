//
//  AddItemViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/21.
//

import UIKit

class AddItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc private func addPetButtonTapped() {
        let viewController = AddPetViewController()
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func addProductButtonTapped() {
        let viewController = AddProductViewController()
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func addTodoButtonTapped() {
        let viewController = AddTodoViewController()
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        
        let mainView = UIView()
        mainView.layer.cornerRadius = 30
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        mainView.backgroundColor = .white
        
        let seperatedView = UIView()
        seperatedView.backgroundColor = .systemGray
        mainView.addSubview(seperatedView)
        seperatedView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.4)
        }
        
        let addPetButton = UIButton()
        mainView.addSubview(addPetButton)
        addPetButton.snp.makeConstraints { make in
            make.top.equalTo(seperatedView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        addPetButton.setTitle("반려동물 추가하기", for: .normal)
        addPetButton.setTitleColor(.black, for: .normal)
        addPetButton.addTarget(self, action: #selector(addPetButtonTapped), for: .touchUpInside)
        
        let addProductButton = UIButton()
        mainView.addSubview(addProductButton)
        addProductButton.snp.makeConstraints { make in
            make.top.equalTo(addPetButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        addProductButton.setTitle("상품 추가하기", for: .normal)
        addProductButton.setTitleColor(.black, for: .normal)
        addProductButton.addTarget(self, action: #selector(addProductButtonTapped), for: .touchUpInside)
        
        let addTodoButton = UIButton()
        mainView.addSubview(addTodoButton)
        addTodoButton.snp.makeConstraints { make in
            make.top.equalTo(addProductButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        addTodoButton.setTitle("일정 추가하기", for: .normal)
        addTodoButton.setTitleColor(.black, for: .normal)
        addTodoButton.addTarget(self, action: #selector(addTodoButtonTapped), for: .touchUpInside)
        
        let cancelButton = UIButton()
        mainView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(addTodoButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        let seperatedBottonView = UIView()
        seperatedBottonView.backgroundColor = .systemGray
        mainView.addSubview(seperatedBottonView)
        seperatedBottonView.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.4)
        }
    }
}
