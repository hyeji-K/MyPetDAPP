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
        imageView.backgroundColor = .ebonyClayColor.withAlphaComponent(0.8)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.1
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let withLabel: UILabel = {
        let label = UILabel()
        label.text = "함께한지"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let withDayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .right
        label.textColor = .appleBlossomColor
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
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
        label.text = "2018. 01. 01."
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    let birthDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birth. 2018. 01. 01."
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
        self.profileImageView.setImageURL(petInfo.image)
        self.birthDayLabel.text = "Birth. \(petInfo.birthDate.dateLong!.stringFormatShort)"
        let withDate = petInfo.withDate.dateLong!
        self.withDateLabel.text = "\(withDate.stringFormatShort) ~"
        let dDay = Calendar.current.dateComponents([.day], from: withDate, to: Date()).day! + 1
        self.withDayLabel.text = "\(dDay)"
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        
        mainView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(70)
        }
        
        mainView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
            make.bottom.equalTo(-70)
        }
        
        profileImageView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(16)
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
        
        profileImageView.addSubview(withDateLabel)
        withDateLabel.snp.makeConstraints { make in
            make.top.equalTo(withLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(16)
        }
        
        profileView.addSubview(petNameLabel)
        petNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(26)
            make.width.equalTo(150)
        }
        
        profileView.addSubview(birthDayLabel)
        birthDayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.left.lessThanOrEqualTo(petNameLabel.snp.right)
        }
        
        self.contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(mainView.snp.bottom).offset(10)
            make.width.equalTo(25)
        }
        
        self.contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.equalTo(deleteButton.snp.left).inset(-20)
            make.top.equalTo(deleteButton.snp.top)
            make.width.equalTo(25)
        }
    }
}
