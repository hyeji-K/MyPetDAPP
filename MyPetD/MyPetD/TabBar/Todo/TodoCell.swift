//
//  TodoCell.swift
//  MyPetD
//
//  Created by heyji on 2022/09/13.
//

import UIKit

class TodoCell: UITableViewCell {
    
    static let cellId: String = "TodoCell"
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .black
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        return button
    }()
    private let todoLabel: UILabel = {
        let label = UILabel()
        label.text = "1시간 놀아주기"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "오후 11:00, 매일"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    private let seperateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setupCell() {
        contentView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-6)
            make.left.equalToSuperview()
            make.width.height.equalTo(30)
        }
        contentView.addSubview(todoLabel)
        todoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkButton.snp.centerY)
            make.left.equalTo(checkButton.snp.right).offset(16)
            make.right.equalToSuperview()
        }
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(todoLabel.snp.bottom).offset(2)
            make.left.equalTo(todoLabel.snp.left)
            make.right.equalToSuperview()
        }
        contentView.addSubview(seperateView)
        seperateView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(descriptionLabel.snp.left)
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }    
}
