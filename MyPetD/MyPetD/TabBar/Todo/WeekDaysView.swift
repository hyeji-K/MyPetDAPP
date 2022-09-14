//
//  WeekDayView.swift
//  MyPetD
//
//  Created by heyji on 2022/09/02.
//

import UIKit

final class WeekDayView: UIView {
    
    private var weekdayArray: [String]
    
    private lazy var weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        self.weekdayArray = Calendar.current.shortWeekdaySymbols
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.weekdayArray = Calendar.current.shortWeekdaySymbols
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        weekdayArray.append(weekdayArray.removeFirst())
        addSubview(weekStackView)
        weekStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        for i in 0..<7 {
            let dayLabel = UILabel()
            dayLabel.text = weekdayArray[i]
            dayLabel.font = UIFont.systemFont(ofSize: 16)
            dayLabel.textAlignment = .center
            dayLabel.textColor = .black
            weekStackView.addArrangedSubview(dayLabel)
        }
    }
}

enum Weekday: String {
    case Mon = "월"
    case Tue = "화"
    case Wed = "수"
    case Thu = "목"
    case Fri = "금"
    case Sat = "토"
    case Sun = "일"
}
