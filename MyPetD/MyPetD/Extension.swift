//
//  Extension.swift
//  MyPetD
//
//  Created by heyji on 2022/09/13.
//

import UIKit

extension Date {
    // get first day of the month
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    // Reminder - Format the date and time
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today, %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText) // 오늘 오후 ㅁ시
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@, %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText) // 10월 14일, ㅁ시
        }
    }
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
    var timeText: String {
        return formatted(date: .omitted, time: .shortened)
    }
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var stringFormat: String {
        return Date.dateFormatter.string(from: self)
    }
    
    static var dateFormatterShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter
    }()
    
    var stringFormatShort: String {
        return Date.dateFormatterShort.string(from: self)
    }
}


// get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
    
    static var dateFormatterLong: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var dateLong: Date? {
        return String.dateFormatterLong.date(from: self)
    }
    
    func dDayFunction(_ date: String) -> String {
        if let date = date.dateLong {
            let dDay = Calendar.current.dateComponents([.day], from: Date(), to: date).day!
            if dDay < 0 {
                return "기한 만료"
            } else if dDay == 0 {
                return "D - Day"
            } else {
                return "D - \(dDay)"
            }
        }
        return "D - 0"
    }
    
//    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
////        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        if let date = dateFormatter.date(from: self) {
//            return date
//        } else {
//            return nil
//        }
//    }
}

extension UIColor {
    static var todayDetailCellTint: UIColor {
        UIColor(named: "TodayDetailCellTint") ?? .tintColor
    }
    
    static var todayListCellBackground: UIColor {
        UIColor(named: "TodayListCellBackground") ?? .secondarySystemBackground
    }
    
    static var todayListCellDoneButtonTint: UIColor {
        UIColor(named: "TodayListCellDoneButtonTint") ?? .tintColor
    }
    
    static var todayGradientAllBegin: UIColor {
        UIColor(named: "TodayGradientAllBegin") ?? .systemFill
    }
    
    static var todayGradientAllEnd: UIColor {
        UIColor(named: "TodayGradientAllEnd") ?? .quaternarySystemFill
    }
    
    static var todayGradientFutureBegin: UIColor {
        UIColor(named: "TodayGradientFutureBegin") ?? .systemFill
    }
    
    static var todayGradientFutureEnd: UIColor {
        UIColor(named: "TodayGradientFutureEnd") ?? .quaternarySystemFill
    }
    
    static var todayGradientTodayBegin: UIColor {
        UIColor(named: "TodayGradientTodayBegin") ?? .systemFill
    }
    
    static var todayGradientTodayEnd: UIColor {
        UIColor(named: "TodayGradientTodayEnd") ?? .quaternarySystemFill
    }
    
    static var todayNavigationBackground: UIColor {
        UIColor(named: "TodayNavigationBackground") ?? .secondarySystemBackground
    }
    
    static var todayPrimaryTint: UIColor {
        UIColor(named: "TodayPrimaryTint") ?? .tintColor
    }
    
    static var todayProgressLowerBackground: UIColor {
        UIColor(named: "TodayProgressLowerBackground") ?? .systemGray
    }
    
    static var todayProgressUpperBackground: UIColor {
        UIColor(named: "TodayProgressUpperBackground") ?? .systemGray6
    }
}

extension UIViewController {
    func alert(_ message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                completion?() // completion 매개변수의 값이 nil이 아닐때에만 실행되도록
            }
            alert.addAction(okAction)
            self.present(alert, animated: false)
        }
    }
}
