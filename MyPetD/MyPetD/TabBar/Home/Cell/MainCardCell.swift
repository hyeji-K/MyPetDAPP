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
        if info.image != "" {
            self.profileImageView.setImageURL(info.image)
        } else {
            self.profileImageView.image = UIImage()
        }
        let withDate = info.withDate.dateLong!
        let dDay = Calendar.current.dateComponents([.day], from: withDate, to: Date()).day! + 1
        self.withDayLabel.text = "\(dDay)"
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = .white
        
        contentView.addSubview(profileImageView)
        profileImageView.addSubview(meLabel)
        profileImageView.addSubview(heartImageView)
        profileImageView.addSubview(petNameLabel)
        profileImageView.addSubview(dayLabel)
        profileImageView.addSubview(withDayLabel)
        profileImageView.addSubview(withLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        meLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        heartImageView.snp.makeConstraints { make in
            make.centerY.equalTo(meLabel.snp.centerY)
            make.right.equalTo(meLabel.snp.left).inset(-4)
        }
        
        petNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(meLabel.snp.centerY)
            make.right.equalTo(heartImageView.snp.left).inset(-4)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(meLabel.snp.bottom).inset(-6)
            make.right.equalToSuperview().inset(16)
        }
        
        withDayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel.snp.centerY)
            make.right.equalTo(dayLabel.snp.left).inset(-4)
        }
        
        withLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel.snp.centerY)
            make.right.equalTo(withDayLabel.snp.left).inset(-4)
        }
    }
}
