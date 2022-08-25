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
        imageView.image = UIImage(systemName: "scribble.variable")
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 10
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
        label.text = "22-10-30 (D-10)"
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
    
    func configuration(title: String) {
        self.titleLabel.text = title
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.borderWidth = 0.1
        self.contentView.layer.borderColor = UIColor.systemGray.cgColor
        self.contentView.layer.cornerRadius = 10

        self.contentView.addSubview(stackView)
//        self.contentView.addSubview(dDayView)
        thumbnailView.addSubview(thumbnailImageView)
//        dDayView.addSubview(dDayLabel)
        
        // 그림자 주려니까 자꾸 뷰 에러 남 --
//        self.contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
//        self.contentView.layer.shadowOpacity = 0.5
//        self.contentView.layer.shadowColor = UIColor.gray.cgColor
//        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.contentView.layer.shadowRadius = 1
//        self.contentView.layer.masksToBounds = false

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        thumbnailImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(65)
        }

//        dDayView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(12)
//            make.right.equalToSuperview().inset(8)
//            make.width.equalTo(35)
//            make.height.equalTo(20)
//        }
//
//        dDayLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
// setConstraint
