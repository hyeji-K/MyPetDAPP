//
//  MainCardCell.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit

class MainCardCell: UICollectionViewCell {
    
    static let cellId: String = "MainCardCell"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .fiordColor
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    let petNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .right
        label.textColor = .white
        label.attributedText = .attributeShadowStyle(text: "petName")
        return label
    }()
    
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = .appleBlossomColor
        imageView.systemImageDropShadow()
        return imageView
    }()
    
    let meLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .right
        label.textColor = .white
        label.attributedText = .attributeShadowStyle(text: "나")
        return label
    }()
    
    let withLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.attributedText = .attributeShadowStyle(text: "함께한지")
        return label
    }()
    
    let withDayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .right
        label.textColor = .appleBlossomColor
        label.attributedText = .attributeShadowStyle(text: "0")
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.attributedText = .attributeShadowStyle(text: "일")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ info: PetInfo) {
        self.petNameLabel.text = info.name
        self.profileImageView.setImageURL(info.image)
        let withDate = info.withDate.dateLong!
        let dDay = Calendar.current.dateComponents([.day], from: withDate, to: Date()).day! + 1
        self.withDayLabel.text = "\(dDay)"
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = .white
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        profileImageView.addSubview(meLabel)
        meLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
        profileImageView.addSubview(heartImageView)
        heartImageView.snp.makeConstraints { make in
            make.centerY.equalTo(meLabel.snp.centerY)
            make.right.equalTo(meLabel.snp.left).inset(-4)
        }
        profileImageView.addSubview(petNameLabel)
        petNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(meLabel.snp.centerY)
            make.right.equalTo(heartImageView.snp.left).inset(-4)
        }
        profileImageView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(meLabel.snp.bottom).inset(-6)
            make.right.equalToSuperview().inset(16)
        }
        profileImageView.addSubview(withDayLabel)
        withDayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel.snp.centerY)
            make.right.equalTo(dayLabel.snp.left).inset(-4)
        }
        profileImageView.addSubview(withLabel)
        withLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel.snp.centerY)
            make.right.equalTo(withDayLabel.snp.left).inset(-4)
        }
    }
}
