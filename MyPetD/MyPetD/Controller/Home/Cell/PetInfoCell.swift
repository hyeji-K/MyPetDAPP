//
//  PetInfoCell.swift
//  MyPetD
//
//  Created by heyji on 2022/08/20.
//

import UIKit

class PetInfoCell: UICollectionViewCell {
    
    static let cellId: String = "PetInfoCell"
    
    let mainView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        return view
    }()
    
    let profileView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .fiordColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let withLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
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
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.attributedText = .attributeShadowStyle(text: "일")
        return label
    }()
    
    let petNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let withDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .right
        label.textColor = .white
        label.attributedText = .attributeShadowStyle(text: "2018. 01. 01. ~")
        return label
    }()
    
    let birthDayLabel: UILabel = {
        let label = UILabel()
        label.text = "생일. 2018. 01. 01."
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    let deleteButton: PetEditButton = {
        let button = PetEditButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let editButton: PetEditButton = {
        let button = PetEditButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ petInfo: PetInfo) {
        self.petNameLabel.text = petInfo.name
        if petInfo.image != "" {
            self.profileImageView.setImageURL(petInfo.image)
        } else {
            self.profileImageView.image = UIImage()
        }
        self.birthDayLabel.text = "생일. \(petInfo.birthDate.dateLong!.stringFormatShort)"
        let withDate = petInfo.withDate.dateLong!
        self.withDateLabel.text = "\(withDate.stringFormatShort) ~"
        let dDay = Calendar.current.dateComponents([.day], from: withDate, to: Date()).day! + 1
        self.withDayLabel.text = "\(dDay)"
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(mainView)
        self.contentView.addSubview(deleteButton)
        self.contentView.addSubview(editButton)
        mainView.addSubview(profileView)
        mainView.addSubview(profileImageView)
        profileImageView.addSubview(dayLabel)
        profileImageView.addSubview(withDayLabel)
        profileImageView.addSubview(withLabel)
        profileImageView.addSubview(withDateLabel)
        profileView.addSubview(petNameLabel)
        profileView.addSubview(birthDayLabel)
        
        mainView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        
        profileView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(70)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
            make.bottom.equalTo(-70)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(16)
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
        
        withDateLabel.snp.makeConstraints { make in
            make.top.equalTo(withLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(16)
        }
        
        petNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(26)
            make.width.equalTo(150)
        }
        
        birthDayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.left.lessThanOrEqualTo(petNameLabel.snp.right)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(mainView.snp.bottom).offset(10)
            make.width.equalTo(25)
        }
        
        editButton.snp.makeConstraints { make in
            make.right.equalTo(deleteButton.snp.left).inset(-20)
            make.top.equalTo(deleteButton.snp.top)
            make.width.equalTo(25)
        }
    }
}
