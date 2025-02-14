//
//  ProductDetailView.swift
//  MyPetD
//
//  Created by heyji on 2022/12/13.
//

import UIKit

final class ProductDetailView: UIView {
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        button.tintColor = .white
        button.imageView?.systemImageDropShadow()
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        button.tintColor = .white
        button.imageView?.systemImageDropShadow()
        return button
    }()
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    var dDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .appleBlossomColor
        label.textAlignment = .right
        return label
    }()
    
    var storedLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.sizeToFit()
        label.textColor = .apricotColor
        label.numberOfLines = 2
        return label
    }()
    
    var storedLabel: UILabel = {
        let label = UILabel()
        label.text = "에 보관중"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    var expirationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    var memoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.shadyLadyColor.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(.appleBlossomColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDetailView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDetailView() {
        addSubview(mainView)
        addSubview(productImageView)
        addSubview(closeButton)
        addSubview(editButton)
        addSubview(productNameLabel)
        addSubview(dDayLabel)
        addSubview(storedLocationLabel)
        addSubview(storedLabel)
        addSubview(expirationLabel)
        addSubview(memoLabel)
        addSubview(deleteButton)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(mainView.snp.height).dividedBy(2)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
        }
        
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
        
        deleteButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(memoLabel.snp.bottom).inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(45)
        }        
    }
}
