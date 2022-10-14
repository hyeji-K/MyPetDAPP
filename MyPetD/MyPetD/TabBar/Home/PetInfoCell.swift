//
//  PetInfoCell.swift
//  MyPetD
//
//  Created by heyji on 2022/08/20.
//

import UIKit

class PetInfoCell: UICollectionViewCell {
    
    static let cellId: String = "PetInfoCell"
    
    weak var viewController: UIViewController?
    
    let mainView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.systemGray.cgColor
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
        imageView.backgroundColor = .systemMint
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(named: "testImage2")
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
        label.textColor = .systemRed
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
        label.textAlignment = .right
        label.textColor = .black
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
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ info: ProfileInfo) {
        self.petNameLabel.text = info.name
        self.profileImageView.setImageURL(info.image)
        self.birthDayLabel.text = "Birth. \(info.birthDate)"
        self.withDateLabel.text = info.withDate
        let withDate = info.withDate.date!
        let dDay = Calendar.current.dateComponents([.day], from: withDate, to: Date()).day! + 1
        self.withDayLabel.text = "\(dDay)"
    }
    
    @objc func removeButtonTapped() {
        print("remove")
        // TODO: 삭제하시겠습니까? 알럿 -> 삭제/취소
        let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            // TODO: 파이어베이스에서 삭제
//            self.ref.child("PetInfo").child("autoId").removeValue()
//            let imageRef = self.storage.child(uid).child("PetImage")
//            let imageName = "\(name).jpg"
//            let imagefileRef = imageRef.child(imageName)
//            imagefileRef.delete()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped() {
        print("edit")
        let addPetViewController = AddPetViewController()
        viewController?.present(addPetViewController, animated: true, completion: nil)
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = .white
        
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
            make.left.equalToSuperview().offset(40)
        }
        
        profileView.addSubview(birthDayLabel)
        birthDayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        self.contentView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(mainView.snp.bottom).offset(10)
        }
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        self.contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.equalTo(removeButton.snp.left).inset(-20)
            make.top.equalTo(removeButton.snp.top)
        }
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
//    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
//        let border = UIView()
//        border.backgroundColor = color
//        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
//        border.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: borderWidth)
//        inputTextField.addSubview(border)
//    }
}

extension CALayer {
    
    func addBorder(_ arrEdge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arrEdge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}

