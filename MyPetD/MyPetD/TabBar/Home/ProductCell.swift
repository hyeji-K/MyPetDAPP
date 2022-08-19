//
//  ProductCell.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit

class ProductCell: UITableViewCell {
    
    static let cellId: String = "ProductCell"
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 10
        return view
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray3
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray.cgColor
//        imageView.image = UIImage(systemName: "pawprint.circle")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
//        label.text = "차오츄르"
        label.backgroundColor = .systemGray3
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
        
    let storedLabel: UILabel = {
        let label = UILabel()
//        label.text = "냉장보관"
        label.backgroundColor = .systemGray3
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    let dDayLabel: UILabel = {
        let label = UILabel()
//        label.text = "D-35"
        label.backgroundColor = .systemGray3
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCell() {
        
        self.contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
        
        cellView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.height.equalTo(60)
        }
        cellView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(productImageView.snp.right).inset(-16)
            make.right.equalToSuperview().inset(100)
            make.height.equalTo(15)
        }
        cellView.addSubview(storedLabel)
        storedLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).inset(-10)
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalToSuperview().inset(100)
            make.height.equalTo(15)
        }
        cellView.addSubview(dDayLabel)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        
        addSubview(likeButton)
    }

}
