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
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.image = UIImage(systemName: "pawprint.circle")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "간식 이름"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        return label
    }()
        
    lazy var storedLabel: UILabel = {
        let label = UILabel()
        label.text = "냉장보관"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D - 0"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
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
        self.productImageView.setImageURL(productInfo.image)
        self.productNameLabel.text = productInfo.name
        self.storedLabel.text = productInfo.storedMethod
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
            make.height.equalTo(80)
        }
        
        productImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.height.equalTo(60)
        }
        productNameLabel.setContentCompressionResistancePriority(.init(rawValue: 750), for: .horizontal)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(productImageView.snp.right).inset(-12)
            make.right.equalTo(dDayLabel.snp.left)
            make.height.equalTo(15)
        }
        
        storedLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).inset(-10)
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        
        dDayLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.left.equalTo(productNameLabel.snp.right)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
    }
}
