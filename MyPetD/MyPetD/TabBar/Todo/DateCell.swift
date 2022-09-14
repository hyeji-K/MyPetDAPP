//
//  DateCell.swift
//  MyPetD
//
//  Created by heyji on 2022/09/05.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    static let cellId: String = "DateCell"
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let completedView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .systemOrange
        imageView.isHidden = true
        return imageView
    }()
    
    let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    func configure(day: String) {
        self.dayLabel.text = day
    }
    
    private func setupCell() {
        addSubview(completedView)
        completedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        addSubview(selectedView)
        selectedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
