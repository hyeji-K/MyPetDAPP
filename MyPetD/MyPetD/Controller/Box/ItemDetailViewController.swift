//
//  ItemDetailViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/26.
//

import UIKit

final class ItemDetailViewController: UIViewController {
    
    private let productDetailView = ProductDetailView()
    var product: Product {
        didSet {
            onChange(product)
        }
    }
    var workingProductInfo: Product
    var onChange: (Product) -> Void
    
    init(product: Product, onChange: @escaping (Product) -> Void) {
        self.product = product
        self.workingProductInfo = product
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
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            NetworkService.shared.deleteImageAndData(with: self.product.id, storageName: .productImage, classification: .productInfo)
            
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
    
    private func update(_ productData: Product) {
        self.productDetailView.productNameLabel.text = productData.name
        self.productDetailView.productImageView.setImageURL(productData.imageUrl)
        self.productDetailView.dDayLabel.text = productData.expirationDate.dDayFunction(productData.expirationDate)
        self.productDetailView.storedLocationLabel.text = productData.storedMethod
        self.productDetailView.expirationLabel.text = "\(productData.expirationDate.dateLong!.stringFormatShort)"
        self.productDetailView.memoLabel.text = productData.memo
    }
    
    private func setupDetailView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        
        self.view.addSubview(productDetailView)
        productDetailView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(self.view.frame.width*4/3)
        }
        
        productDetailView.layer.cornerRadius = 10
        productDetailView.clipsToBounds = true
        
        productDetailView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        productDetailView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        productDetailView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        self.update(product)
    }
}
