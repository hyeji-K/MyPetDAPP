//
//  ItemDetailViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/26.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ItemDetailViewController: UIViewController {
    
    var productInfo: ProductInfo?
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailView()
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "정말로 삭제하시겠습니까?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            print("삭제하겠습니다.")
            
            let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
            // TODO: 데이터와 이미지 삭제
            print("이미지 삭제")
            let imageRef = self.storage.child(uid).child("ProductImage")
            let imageName = "\((self.productInfo?.nameOfProduct)!).jpg"
            imageRef.child(imageName).delete { error in
                if let error = error {
                    print(error)
                } else {
                    print("삭제되었습니다.")
                }
            }
            print("데이터 삭제")
            self.ref = Database.database().reference(withPath: uid)
            let productId = (self.productInfo?.id)!
            self.ref.child("ProductInfo").child(productId).removeValue()
            print("삭제 완료")
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func editButtonTapped() {
        print("edit button tapped")
        
        // 데이터가 있는 상태의 추가하기 뷰로 이동
        let addProductViewController = AddProductViewController()
        self.present(addProductViewController, animated: true, completion: nil)
        // 저장 버튼을 클릭했을 때 두 모달 모두 dismiss
    }
    
    private func setupDetailView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        
        let mainView = UIView()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(self.view.frame.width*4/3)
        }
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
        
        let productImageView = UIImageView()
        guard let urlString = productInfo?.imageOfProduct else { return }
        productImageView.setImageURL(urlString)
        mainView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.view.frame.width*2/3)
        }
        productImageView.backgroundColor = .white
        productImageView.contentMode = .scaleAspectFill
        productImageView.isUserInteractionEnabled = true
        productImageView.layer.masksToBounds = true
        
        let closeButton = UIButton()
        productImageView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let editButton = UIButton()
        mainView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
        }
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .black
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        let productNameLabel = UILabel()
        mainView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        productNameLabel.text = productInfo?.nameOfProduct
        productNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let dDayLabel = UILabel()
        mainView.addSubview(dDayLabel)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(16)
            make.left.greaterThanOrEqualTo(productNameLabel.snp.right).offset(10)
        }
        guard let dday = productInfo?.expirationDate.date else { return }
        let dDay = Calendar.current.dateComponents([.day], from: Date(), to: dday).day!
        if dDay < 0 {
            dDayLabel.text = "D - 0"
        } else {
            dDayLabel.text = "D - \(dDay)"
        }
        dDayLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        dDayLabel.textColor = .systemMint
        dDayLabel.textAlignment = .right
        
        let storedLocationLabel = UILabel()
        mainView.addSubview(storedLocationLabel)
        storedLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        storedLocationLabel.text = productInfo?.storedMethod
        storedLocationLabel.textColor = .systemMint
        storedLocationLabel.numberOfLines = 2
        
        let storedLabel = UILabel()
        mainView.addSubview(storedLabel)
        storedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(storedLocationLabel.snp.centerY)
            make.left.equalTo(storedLocationLabel.snp.right).offset(6)
            make.width.equalTo(80)
            make.left.greaterThanOrEqualTo(storedLocationLabel.snp.right).inset(10)
        }
        storedLabel.text = "에 보관중"
        
        let expirationLabel = UILabel()
        mainView.addSubview(expirationLabel)
        expirationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(storedLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(110)
            make.left.greaterThanOrEqualTo(storedLabel.snp.right).inset(10)
        }
        guard let exprirationDate = productInfo?.expirationDate else { return }
        expirationLabel.text = "\(exprirationDate) 까지"
        expirationLabel.textAlignment = .right
        expirationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        let memoLabel = UILabel()
        mainView.addSubview(memoLabel)
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(storedLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        memoLabel.text = productInfo?.memo
        memoLabel.numberOfLines = 3
        
        let deleteButton = UIButton()
        mainView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(memoLabel.snp.bottom).inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(45)
        }
        deleteButton.backgroundColor = .systemMint
        deleteButton.layer.cornerRadius = 10
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
}
