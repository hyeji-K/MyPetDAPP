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
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.sizeToFit()
        label.textColor = .systemMint
        label.numberOfLines = 2
        return label
    }()
    lazy var storedLabel: UILabel = {
        let label = UILabel()
        label.text = "에 보관중"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    lazy var expirationLabel: UILabel = {
        let label = UILabel()
        label.text = "\(productInfo.expirationDate.dateLong!.stringFormatShort)"
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.text = productInfo.memo
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
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
        self.expirationLabel.text = "\(product.expirationDate.dateLong!.stringFormatShort)"
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
        mainView.addSubview(dDayLabel)
        mainView.addSubview(storedLocationLabel)
        mainView.addSubview(storedLabel)
        mainView.addSubview(expirationLabel)
        mainView.addSubview(memoLabel)
        
        productNameLabel.setContentCompressionResistancePriority(.init(rawValue: 750), for: .horizontal)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(dDayLabel.snp.left)
        }
        
        dDayLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(productNameLabel.snp.right)
            make.width.equalTo(100)
        }
        storedLocationLabel.setContentCompressionResistancePriority(.init(rawValue: 750), for: .horizontal)
        storedLocationLabel.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        storedLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(storedLabel.snp.left)
        }
        
        storedLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        storedLabel.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        storedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(storedLocationLabel.snp.centerY)
            make.left.equalTo(storedLocationLabel.snp.right)
            make.right.equalTo(expirationLabel.snp.left)
        }
        
        expirationLabel.snp.makeConstraints { make in
            make.top.equalTo(storedLabel.snp.top)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(storedLabel.snp.right)
            make.width.equalTo(100)
        }
        
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
        deleteButton.backgroundColor = .white
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.borderColor = UIColor.systemGray.cgColor
        deleteButton.layer.borderWidth = 0.5
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
}
