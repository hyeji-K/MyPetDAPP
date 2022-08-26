//
//  ProductDetailViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import UIKit

class ProductDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "정말로 삭제하시겠습니까?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            print("삭제되었습니다.")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        // 편집 네비게이션바 아이템 추가
        // 편집 누르면 데이터가 있는 상태의 추가하기 뷰로 이동
        let productImageView = UIImageView()
        self.view.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.view.frame.width)
            
        }
        productImageView.backgroundColor = .systemMint
        productImageView.contentMode = .scaleAspectFit
        
        let productNameLabel = UILabel()
        self.view.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        productNameLabel.text = "로얄캐닌 인도어"
        productNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let dDayLabel = UILabel()
        self.view.addSubview(dDayLabel)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(16)
            make.left.greaterThanOrEqualTo(productNameLabel.snp.right).offset(10)
        }
        dDayLabel.text = "D - 123"
        dDayLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        dDayLabel.textColor = .systemMint
        dDayLabel.textAlignment = .right
        
        let storedLocationLabel = UILabel()
        self.view.addSubview(storedLocationLabel)
        storedLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        storedLocationLabel.text = "냉장고"
        storedLocationLabel.textColor = .systemMint
        
        let storedLabel = UILabel()
        self.view.addSubview(storedLabel)
        storedLabel.snp.makeConstraints { make in
            make.top.equalTo(storedLocationLabel.snp.top)
            make.left.equalTo(storedLocationLabel.snp.right).offset(6)
        }
        storedLabel.text = "에 보관중"
        
        let expirationLabel = UILabel()
        self.view.addSubview(expirationLabel)
        expirationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(storedLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
            make.left.greaterThanOrEqualTo(storedLabel.snp.right).inset(10)
        }
        expirationLabel.text = "2022-10-30 까지"
        expirationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        let memoLabel = UILabel()
        self.view.addSubview(memoLabel)
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(storedLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        memoLabel.text = "우리 고양이들이 잘 먹는 사료임! 베스트! ⭐️"
        memoLabel.numberOfLines = 4
        
        let deleteButton = UIButton()
        self.view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(memoLabel.snp.bottom).inset(20)
            make.bottom.equalToSuperview().inset(45)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        deleteButton.backgroundColor = .systemMint
        deleteButton.layer.cornerRadius = 10
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
}
