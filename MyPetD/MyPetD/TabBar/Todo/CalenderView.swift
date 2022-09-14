//
//  CalenderView.swift
//  MyPetD
//
//  Created by heyji on 2022/09/02.
//

import UIKit

final class CalenderView: UIView, MonthViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var numOfDaysInMonth: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    private var currentMonthIndex: Int = 0
    private var currentYear: Int = 0
    private var presentMonthIndex: Int = 0
    private var presentYear: Int = 0
    private var todayDate: Int = 0
    private var firstWeekDayOfMonth: Int = 0   // (Sunday-Saturday 1-7)
    private let todoView: TodoView = TodoView()
    
    private let monthView: MonthView = {
        let view = MonthView()
        return view
    }()

    private let weekdayView: WeekDayView = {
        let view = WeekDayView()
        return view
    }()
    
    let calenderCollecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.allowsMultipleSelection = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    
    private func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todayDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        // for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        // end
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        calenderCollecionView.delegate = self
        calenderCollecionView.dataSource = self
        calenderCollecionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.cellId)
        
        setupView()
        
        self.calenderCollecionView.reloadData()
        self.calenderCollecionView.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfDate = numOfDaysInMonth[currentMonthIndex - 1] + firstWeekDayOfMonth - 1
        let numberOfItemsSection = numberOfDate % 7 == 0 ? numberOfDate : numberOfDate + ( 7 - (numberOfDate % 7 ))
        return numberOfItemsSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.cellId, for: indexPath) as? DateCell else { return UICollectionViewCell() }
        cell.backgroundColor = .clear
        cell.selectedView.backgroundColor = .clear
        
        let previousMonth = monthView.currentMonthIndex < 1 ? 12 : monthView.currentMonthIndex - 1
        
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            // 이전달
            let previousMonthDate = previousMonth == 12 ? numOfDaysInMonth[0] : numOfDaysInMonth[previousMonth]
            let date = previousMonthDate - (firstWeekDayOfMonth - 2) + indexPath.item
            cell.configure(day: "\(date)")
            cell.dayLabel.textColor = UIColor.lightGray
        } else if indexPath.item >= numOfDaysInMonth[currentMonthIndex - 1] + firstWeekDayOfMonth - 1 {
            // 다음달
            let nextMonthDate = previousMonth + 1 < 13 ? numOfDaysInMonth[previousMonth + 1] : numOfDaysInMonth[0]
            let date = indexPath.item - nextMonthDate - firstWeekDayOfMonth + 2
            cell.dayLabel.text = "\(date)"
            cell.dayLabel.textColor = UIColor.lightGray
        } else {
            // 현재달
            let calcDate = indexPath.item - firstWeekDayOfMonth + 2
            cell.dayLabel.text = "\(calcDate)"
            if calcDate == todayDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled = true
                cell.dayLabel.textColor = .black
                cell.backgroundColor = .systemTeal
            } else {
                cell.isUserInteractionEnabled = true
                cell.dayLabel.textColor = .black
            }
            
            if indexPath.item % 7 == 6 {
                cell.dayLabel.textColor = .red
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        cell.selectedView.backgroundColor = .systemGray
//        todoView.todoTableView.reloadData()
//        todoView.titleLabel.text = (cell.dayLabel.text)!
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        if indexPath[1] + 1 == todayDate {
            cell.selectedView.backgroundColor = .systemTeal
        } else {
            cell.selectedView.backgroundColor = .clear
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let numberOfItemsPerRow: CGFloat = 7
        let spacing: CGFloat = 8
        let availableWidth = width - (spacing * (numberOfItemsPerRow + 1))
        let itemDimension = availableWidth / numberOfItemsPerRow
        return CGSize(width: itemDimension, height: itemDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    private func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)! - 1
        return day
    }

    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year

        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        // end

        firstWeekDayOfMonth = getFirstWeekDay()

        calenderCollecionView.reloadData()
        calenderCollecionView.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    private func setupView() {
        addSubview(monthView)
        monthView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        monthView.delegate = self
        addSubview(weekdayView)
        weekdayView.snp.makeConstraints { make in
            make.top.equalTo(monthView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        addSubview(calenderCollecionView)
        calenderCollecionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !(__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize)){
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let width = calenderCollecionView.collectionViewLayout.collectionViewContentSize.width
        let height = calenderCollecionView.collectionViewLayout.collectionViewContentSize.height
        return CGSize(width: width, height: height + 70)
    }
}

extension UICollectionView {
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
    }
}
