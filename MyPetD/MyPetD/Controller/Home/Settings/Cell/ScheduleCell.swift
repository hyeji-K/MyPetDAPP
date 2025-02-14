//
//  ScheduleCell.swift
//  MyPetD
//
//  Created by heyji on 2024/01/29.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    
    static let identifier: String = "ScheduleCell"
    
    private let cellView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.borderColor = UIColor.rumColor.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 45 / 2
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateImageView, dateLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        return stackView
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "place")
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemGray2
        return label
    }()
    
    lazy var locationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationImageView, locationLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateStackView, locationStackView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .fiordColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.font = .boldSystemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    func configure(_ info: FairSchedule) {
        monthLabel.text = info.month
        titleLabel.text = info.title
        dateLabel.text = info.date
        locationLabel.text = info.location
        switch info.tagName {
        case "#강아지":
            tagLabel.backgroundColor = .appleBlossomColor
        default:
            tagLabel.backgroundColor = .fiordColor
        }
        tagLabel.text = info.tagName
    }
    
    func updateCoverView(date: String) {
        let now = Date()
        let dateList = date.split(separator: "~")
        var dayList = dateList.last?.split(separator: " ")
        dayList?.removeLast()
        if let dayList = dayList {
            let dateString = dayList.reduce("2025년") { $0 + $1 }
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "YYYY년M월d일"

            if let date = formatter.date(from: dateString) {
                if date < now {
                    coverView.isHidden = false
                } else {
                    coverView.isHidden = true
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.contentView.addSubview(cellView)
        cellView.addSubview(monthLabel)
        cellView.addSubview(stackView)
        cellView.addSubview(tagLabel)
        cellView.addSubview(coverView)
        
        cellView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(96)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.width.height.equalTo(45)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.equalTo(monthLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
            make.height.equalTo(18)
            make.width.equalTo(49)
        }
        
        dateImageView.snp.makeConstraints { make in
            make.height.width.equalTo(18)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.height.width.equalTo(18)
        }
        
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
