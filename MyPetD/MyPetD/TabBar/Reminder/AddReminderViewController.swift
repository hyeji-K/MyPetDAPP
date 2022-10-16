//
//  AddReminderViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/10/14.
//

import UIKit

final class AddReminderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        print("save button tapped")
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.resignFirstResponder()
        
        let navigationBar = UINavigationBar()
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
//        navigationBar.backgroundColor = .systemOrange
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = .black
        navigationBar.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let saveButton = UIButton()
        saveButton.setTitle("추가", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        navigationBar.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let todoTextField = UITextField()
        self.view.addSubview(todoTextField)
        todoTextField.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(20)
        }
        todoTextField.borderStyle = .none
        todoTextField.placeholder = "할일을 입력하세요."
        
        let lineView = UIView()
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(todoTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        lineView.backgroundColor = .systemOrange
        
        let repeatLabel = UILabel()
        repeatLabel.text = "반복 주기"
        repeatLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        self.view.addSubview(repeatLabel)
        repeatLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let collectionView: RepeatButtonView = RepeatButtonView()
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(repeatLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(25)
        }
        collectionView.collectionView.delegate = self
        
        let timeLabel = UILabel()
        timeLabel.text = "날짜와 시간"
        timeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        self.view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let timePickerView = UIDatePicker()
        timePickerView.preferredDatePickerStyle = .inline
        timePickerView.datePickerMode = .dateAndTime
        timePickerView.minuteInterval = 5
        timePickerView.tintColor = .systemOrange
        self.view.addSubview(timePickerView)
        timePickerView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}

extension AddReminderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RepeatCell else { return }
        cell.titleLabel.textColor = .systemOrange
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RepeatCell else { return }
        cell.titleLabel.textColor = .black
    }
}

