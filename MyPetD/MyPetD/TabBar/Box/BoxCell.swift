//
//  BoxCell.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import UIKit

class BoxCell: UICollectionViewCell {
    
    static let identifier: String = "BoxCell"
    
    let thumbnailView: UIView = {
        let view = UIView()
        return view
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pawprint.circle.fill")
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
//    var dDayView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemMint
//        view.layer.borderColor = UIColor.systemMint.cgColor
//        view.layer.borderWidth = 0.8
//        view.layer.cornerRadius = 4
//        return view
//    }()
//
//    let dDayLabel: UILabel = {
//        let label = UILabel()
//        label.text = "D-3"
//        label.font = UIFont.systemFont(ofSize: 12)
//        return label
//    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let expirationLabel: UILabel = {
        let label = UILabel()
        label.text = Date.now.stringFormatShort
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailView, titleLabel, expirationLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }
    
    func configuration(_ productInfo: ProductInfo) {
        self.titleLabel.text = productInfo.name
        self.thumbnailImageView.setImageURL(productInfo.image)
        self.expirationLabel.text = productInfo.expirationDate.dateLong?.stringFormatShort
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = .systemGray6
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.systemGray.cgColor
        self.contentView.layer.cornerRadius = 10

//        TODO: ContentView 그림자 주기 (현재는 에러남)
//        self.contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
//        self.contentView.layer.shadowOpacity = 0.5
//        self.contentView.layer.shadowColor = UIColor.gray.cgColor
//        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.contentView.layer.shadowRadius = 1
//        self.contentView.layer.masksToBounds = false

        self.contentView.addSubview(stackView)
        thumbnailView.addSubview(thumbnailImageView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(65)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
