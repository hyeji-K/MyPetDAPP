//
//  ItemDetailViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/26.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    var productInfo: ProductInfo {
        didSet {
            onChange(productInfo)
        }
    }
    var workingProductInfo: ProductInfo
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        let urlString = productInfo.image
        imageView.setImageURL(urlString)
        imageView.backgroundColor = .systemGray6
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
        label.text = productInfo.expirationDate.dDayFunction(productInfo.expirationDate)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .appleBlossomColor
        label.textAlignment = .right
        return label
    }()
    lazy var storedLocationLabel: UILabel = {
        let label = UILabel()
        label.text = productInfo.storedMethod
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.sizeToFit()
        label.textColor = .apricotColor
        label.numberOfLines = 2
        return label
    }()
    lazy var storedLabel: UILabel = {
        let label = UILabel()
        label.text = "에 보관중"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    lazy var expirationLabel: UILabel = {
        let label = UILabel()
        label.text = "\(productInfo.expirationDate.dateLong!.stringFormatShort)"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
    
    init(productInfo: ProductInfo, onChange: @escaping (ProductInfo) -> Void) {
        self.productInfo = productInfo
        self.workingProductInfo = productInfo
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // 배경 터치시 현재 뷰 컨트롤러 내리기
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        print("삭제합니다")
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            NetworkService.shared.deleteImageAndData(with: self.productInfo.id, storageName: .productImage, classification: .productInfo)
            
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
        let viewController = ProductViewController(product: self.workingProductInfo) { productInfo in
            self.workingProductInfo = productInfo
            self.update(productInfo)
        }
        let navigationContoller = UINavigationController(rootViewController: viewController)
        navigationContoller.navigationBar.tintColor = .black
        self.present(navigationContoller, animated: true)
    }
    
    func update(_ productInfo: ProductInfo) {
        self.productNameLabel.text = productInfo.name
        self.productImageView.setImageURL(productInfo.image)
        self.dDayLabel.text = productInfo.expirationDate.dDayFunction(productInfo.expirationDate)
        self.storedLocationLabel.text = productInfo.storedMethod
        self.expirationLabel.text = "\(productInfo.expirationDate.dateLong!.stringFormatShort)"
        self.memoLabel.text = productInfo.memo
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
        closeButton.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.imageView?.systemImageDropShadow()
        
        let editButton = UIButton()
        mainView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
        }
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        editButton.tintColor = .white
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        editButton.imageView?.systemImageDropShadow()
        
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
        deleteButton.layer.borderColor = UIColor.shadyLadyColor.cgColor
        deleteButton.layer.borderWidth = 0.5
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.setTitleColor(.appleBlossomColor, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
}
