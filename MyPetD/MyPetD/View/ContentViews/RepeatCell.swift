//
//  RepeatCell.swift
//  MyPetD
//
//  Created by heyji on 2022/10/16.
//

import UIKit

class RepeatCell: UICollectionViewCell {
    static let cellID = "RepeatCell"
    
    override var isSelected: Bool {
        didSet {
            self.cellView.backgroundColor = isSelected ? .shadyLadyColor : .clear
            self.titleLabel.textColor = isSelected ? .white : .black
            self.titleLabel.font = isSelected ?  .boldSystemFont(ofSize: 18) : .systemFont(ofSize: 16)
        }
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    private func setupCell() {
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview()
        }
        
        cellView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
