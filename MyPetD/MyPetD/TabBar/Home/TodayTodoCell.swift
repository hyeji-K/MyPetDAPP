//
//  TodayTodoCell.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit

class TodayTodoCell: UITableViewCell {
    
    static let cellId: String = "TodayTodoCell"
    
    let cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray3
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let repeatLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray3
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let seperatedView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
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
            make.edges.equalToSuperview()
        }
        cellView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(25)
        }
        cellView.addSubview(repeatLabel)
        repeatLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        cellView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(checkButton.snp.right).inset(-10)
            make.right.equalTo(repeatLabel.snp.left).inset(-10)
            make.height.equalTo(20)
        }
        cellView.addSubview(seperatedView)
        seperatedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
