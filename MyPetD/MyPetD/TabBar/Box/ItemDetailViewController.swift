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
    
    var productInfo: ProductInfo {
        didSet {
            onChange(productInfo)
        }
    }
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        let urlString = productInfo.image
        imageView.setImageURL(urlString)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = productInfo.name
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = dDayFunction(productInfo.expirationDate)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemMint
        label.textAlignment = .right
        return label
    }()
    lazy var storedLocationLabel: UILabel = {
        let label = UILabel()
        label.text = productInfo.storedMethod
        label.textColor = .systemMint
        label.numberOfLines = 2
        return label
    }()
    lazy var expirationLabel: UILabel = {
        let label = UILabel()
        label.text = "\(productInfo.expirationDate.dateLong!.stringFormatShort) 까지"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.text = productInfo.memo
        label.numberOfLines = 3
        return label
    }()
    
    var onChange: (ProductInfo) -> Void
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()
    
    
    init(productInfo: ProductInfo, onChange: @escaping (ProductInfo) -> Void) {
        self.productInfo = productInfo
        self.onChange = onChange
        super.init(nibName: nil, bundle: nil)
        self.setupDetailView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailView()
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "정말로 삭제하시겠습니까?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
            // MARK: 데이터와 이미지 삭제
            let imageRef = self.storage.child(uid).child("ProductImage")
            let imageName = "\(self.productInfo.id).jpg"
            imageRef.child(imageName).delete { error in
                if let error = error {
                    print(error)
                } else {
                    print("삭제되었습니다.")
                }
            }
            self.ref = Database.database().reference(withPath: uid)
            let productId = self.productInfo.id
            self.ref.child("ProductInfo").child(productId).removeValue()
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
        let viewController = ProductViewController(product: self.productInfo) { productInfo in
            print("편집 버튼 클릭시")
            self.update(productInfo)
        }
        let navigationContoller = UINavigationController(rootViewController: viewController)
        self.present(navigationContoller, animated: true)
    }
    
    func update(_ product: ProductInfo) {
        self.productNameLabel.text = product.name
        self.productImageView.setImageURL(product.image)
        self.dDayLabel.text = self.dDayFunction(product.expirationDate)
        self.storedLocationLabel.text = product.storedMethod
        self.expirationLabel.text = "\(product.expirationDate.dateLong!.stringFormatShort) 까지"
        self.memoLabel.text = product.memo
    }
    
    func dDayFunction(_ date: String) -> String {
        if let date = date.dateLong {
            let dDay = Calendar.current.dateComponents([.day], from: Date(), to: date).day!
            if dDay < 0 {
                return "D - 0"
            } else {
                return "D - \(dDay)"
            }
        }
        return "D - 0"
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
        
        mainView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.view.frame.width*2/3)
        }
        
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
        
        mainView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        mainView.addSubview(dDayLabel)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(16)
            make.left.greaterThanOrEqualTo(productNameLabel.snp.right).offset(10)
        }
        
        mainView.addSubview(storedLocationLabel)
        storedLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        let storedLabel = UILabel()
        mainView.addSubview(storedLabel)
        storedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(storedLocationLabel.snp.centerY)
            make.left.equalTo(storedLocationLabel.snp.right).offset(6)
            make.width.equalTo(80)
            make.left.greaterThanOrEqualTo(storedLocationLabel.snp.right).inset(10)
        }
        storedLabel.text = "에 보관중"
        
        mainView.addSubview(expirationLabel)
        expirationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(storedLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(110)
            make.left.greaterThanOrEqualTo(storedLabel.snp.right).inset(10)
        }
        
        mainView.addSubview(memoLabel)
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(storedLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
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
