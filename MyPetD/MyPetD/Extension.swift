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
//        let timeText = formatted(date: .omitted, time: .shortened)
        let timeText = Date.timeFormatterShort.string(from: self)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("오늘, %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText) // 오늘 오후 ㅁ시
        } else if Locale.current.calendar.isDateInYesterday(self) {
            let dateText = formatted(.dateTime.month(.wide).day().locale(Locale(identifier: "ko_KR")))
            let dateAndTimeFormat = NSLocalizedString("어제, %@, %@", comment: "Today at time format string")
            return String(format: dateAndTimeFormat, dateText, timeText) // 어제 10월 14일, ㅁ시, 오후 ㅁ시
        } else if Locale.current.calendar.isDateInTomorrow(self) {
            let dateText = formatted(.dateTime.month(.wide).day().locale(Locale(identifier: "ko_KR")))
            let dateAndTimeFormat = NSLocalizedString("내일, %@, %@", comment: "Today at time format string")
            return String(format: dateAndTimeFormat, dateText, timeText) // 내일 10월 14일, ㅁ시, 오후 ㅁ시
        } else {
            // 현재년도 일때와 아닐때 구분
            let currentYear = Date.now
            if Locale.current.calendar.isDate(currentYear, equalTo: self, toGranularity: .year) {
                let dateText = formatted(.dateTime.month(.wide).day().locale(Locale(identifier: "ko_KR")))
                let dateAndTimeFormat = NSLocalizedString("%@, %@", comment: "Date and time format string")
                return String(format: dateAndTimeFormat, dateText, timeText) // 10월 14일, ㅁ시, 오후 ㅁ시
            } else {
                let dateText = formatted(.dateTime.year().month(.wide).day().locale(Locale(identifier: "ko_KR")))
                let dateAndTimeFormat = NSLocalizedString("%@, %@", comment: "Date and time format string")
                return String(format: dateAndTimeFormat, dateText, timeText) // 10월 14일, 2022, ㅁ시, 오후 ㅁ시
            }
        }
    }
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
//            return NSLocalizedString("Today", comment: "Today due date description")
            return formatted(.dateTime.year().month(.wide).day().weekday(.wide).locale(Locale(identifier: "ko_KR")))
        } else {
            return formatted(.dateTime.year().month(.wide).day().weekday(.wide).locale(Locale(identifier: "ko_KR")))
        }
    }
    var timeText: String {
//        return formatted(date: .omitted, time: .shortened)
        return Date.timeFormatter.string(from: self)
    }
    
    static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static var timeFormatterShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
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
        formatter.dateFormat = "yyyy. MM. dd."
        return formatter
    }()
    
    var stringFormatShort: String {
        return Date.dateFormatterShort.string(from: self)
    }
    
    static var dateFormatterShortline: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var stringFormatShortline: String {
        return Date.dateFormatterShortline.string(from: self)
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

extension NSAttributedString {
    class func attributeShadowStyle(text: String) -> NSAttributedString {
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 2
        
        let attrs: [NSAttributedString.Key: Any] = [
            .shadow: shadow
        ]
        
        let attrString = NSMutableAttributedString(string: text, attributes: attrs)
        
        return attrString
    }
}

extension UIImageView {
    func systemImageDropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.masksToBounds = false
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    static var apricotColor: UIColor {
        UIColor(named: "apricotColor") ?? UIColor(hex: 0xE99E75)
    }
    
    static var rumColor: UIColor {
        UIColor(named: "rumColor") ?? UIColor(hex: 0x776483)
    }
    
    static var shadyLadyColor: UIColor {
        UIColor(named: "shadyLadyColor") ?? UIColor(hex: 0xBBAAB8)
    }
    
    static var fiordColor: UIColor {
        UIColor(named: "fiordColor") ?? UIColor(hex: 0x44426E)
    }
    
    static var ebonyClayColor: UIColor {
        UIColor(named: "ebonyClayColor") ?? UIColor(hex: 0x292643)
    }
    
    static var appleBlossomColor: UIColor {
        UIColor(named: "appleBlossomColor") ?? UIColor(hex: 0xAF4F41)
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
