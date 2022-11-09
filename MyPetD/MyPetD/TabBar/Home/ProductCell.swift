//
//  ProductCell.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit

class ProductCell: UITableViewCell {
    
    static let cellId: String = "ProductCell"
    
    lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.image = UIImage(systemName: "pawprint.fill")
        imageView.tintColor = .fiordColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "상품명"
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
        
    lazy var storedLabel: UILabel = {
        let label = UILabel()
        label.text = "보관장소"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D - 0"
        label.textAlignment = .right
        label.textColor = .appleBlossomColor
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
//    let likeButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "heart"), for: .normal)
//        return button
//    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ productInfo: ProductInfo) {
        if productInfo.image != "" {
            self.productImageView.setImageURL(productInfo.image)
        } else {
            self.productImageView.image = UIImage(systemName: "pawprint.fill")
        }
        self.productNameLabel.text = productInfo.name
        if productInfo.storedMethod != "" {
            self.storedLabel.text = "\(productInfo.storedMethod)에 보관중"
        } else {
            self.storedLabel.text = productInfo.storedMethod
        }
        let dDay = productInfo.expirationDate.dDayFunction(productInfo.expirationDate)
        self.dDayLabel.text = dDay
    }
    
    private func setupCell() {
        
        self.contentView.addSubview(cellView)
        cellView.addSubview(productImageView)
        cellView.addSubview(productNameLabel)
        cellView.addSubview(storedLabel)
        cellView.addSubview(dDayLabel)
        
        cellView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        productImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.height.equalTo(45)
        }
        productNameLabel.setContentCompressionResistancePriority(.init(rawValue: 750), for: .horizontal)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(productImageView.snp.right).inset(-12)
            make.right.equalTo(dDayLabel.snp.left)
            make.height.equalTo(15)
        }
        
        storedLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).inset(-8)
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        
        dDayLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.top)
            make.right.equalToSuperview().inset(10)
            make.left.equalTo(productNameLabel.snp.right)
            make.width.equalTo(80)
            make.height.equalTo(17)
        }
    }
}
