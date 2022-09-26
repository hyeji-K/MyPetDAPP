//
//  TodoInfo.swift
//  MyPetD
//
//  Created by heyji on 2022/09/16.
//

import Foundation

struct TodoInfo: Hashable, Identifiable {
    // 날짜, 할일, 알림시간, 반복주기
    let id: Int
    let isDone: Bool
    let date: String // Date
    let todo: String
    let time: String
    let repeatCycle: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id, "isDone": isDone, "date": date, "todo": todo, "time": time, "repeatCycle": repeatCycle]
        return dict
    }
    
    static var id: Int = 0
}

enum Repeat: String {
    case none = "없음"
    case everyDay = "매일"
    case everyWeek = "매주"
    case everyMonth = "매월"
    case everyYear = "매년"
//    case userCustom = "직접 입력"
}

extension TodoInfo {
    static let list = [
        TodoInfo(id: 0, isDone: false, date: "2022-09-26", todo: "밥 주기", time: "11:00 AM", repeatCycle: "매일"),
        TodoInfo(id: 2, isDone: false, date: "2022-09-26", todo: "1시간 놀아주기", time: "11:00 PM", repeatCycle: "매일"),
    ]
}
