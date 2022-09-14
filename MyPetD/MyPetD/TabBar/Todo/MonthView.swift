//
//  MonthView.swift
//  MyPetD
//
//  Created by heyji on 2022/09/02.
//

import UIKit

protocol MonthViewDelegate: AnyObject {
    func didChangeMonth(monthIndex: Int, year: Int)
}

final class MonthView: UIView {
    
    private var monthArray: [String]
    var currentYear: Int
    var currentMonthIndex: Int
    var delegate: MonthViewDelegate?
    
    private let calendarNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Month Year text"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftButton, todayButton, rightButton])
        stackView.spacing = 6
        return stackView
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(leftRightButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(leftRightButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let todayButton: UIButton = {
        let button = UIButton()
        button.setTitle("오늘", for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(todayButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        // 애플 캘린더의 month 리턴은 1부터(1월 – 12월)입니다.
        self.currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        self.currentYear = Calendar.current.component(.year, from: Date())
        self.monthArray = Calendar.current.shortMonthSymbols
        super.init(frame: frame)
        
        setupView()
        
        todayButton.isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        self.currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        self.currentYear = Calendar.current.component(.year, from: Date())
        self.monthArray = Calendar.current.shortMonthSymbols
        super.init(coder: coder)
        setupView()
    }
    
    @objc private func leftRightButtonAction(sender: UIButton) {
        if sender == rightButton {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
            setTodayButton()
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
            setTodayButton()
        }
        calendarNameLabel.text = "\(monthArray[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    @objc private func todayButtonAction(sender: UIButton) {
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        calendarNameLabel.text = "\(monthArray[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
        setTodayButton()
    }
    
    private func setTodayButton() {
        if currentMonthIndex == Calendar.current.component(.month, from: Date()) - 1 && currentYear == Calendar.current.component(.year, from: Date()) {
            todayButton.setTitleColor(.systemGray4, for: .normal)
            todayButton.isEnabled = false
        } else {
            todayButton.isEnabled = true
            todayButton.setTitleColor(.black, for: .normal)
        }
    }
    
    private func setupView() {
        addSubview(calendarNameLabel)
        calendarNameLabel.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
        }
        calendarNameLabel.text = "\(monthArray[currentMonthIndex]) \(currentYear)"
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}
