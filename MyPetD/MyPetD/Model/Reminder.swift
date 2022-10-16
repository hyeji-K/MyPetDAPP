//
//  Reminder.swift
//  MyPetD
//
//  Created by heyji on 2022/10/14.
//

import Foundation

struct Reminder: Equatable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var dueDate: Date
    var repeatCycle: String = "반복없음"
    var isComplete: Bool = false
}

extension Array where Element == Reminder {
    func indexOfReminder(with id: Reminder.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
// 릴리스용 앱을 빌드할 때 동봉된 코드가 컴파일되지 않도록 하는 컴파일 지시문입니다.
// 디버그 빌드에서 코드를 테스트하거나 다음 단계에서 하는 것처럼 샘플 테스트 데이터를 제공하기 위해 이 플래그를 사용할 수 있습니다.
extension Reminder {
    static var sampleData = [
        Reminder(title: "밥 주기", dueDate: Date().addingTimeInterval(800.0), repeatCycle: "매일", isComplete: true),
        Reminder(title: "화장실 청소하기", dueDate: Date().addingTimeInterval(3200.0), repeatCycle: "매일"),
        Reminder(title: "1시간 놀아주기", dueDate: Date().addingTimeInterval(3200.0), repeatCycle: "매일"),
        Reminder(title: "야옹이들 빗질해주기", dueDate: Date().addingTimeInterval(92500.0), repeatCycle: "매주"),
        Reminder(title: "리터락커 리필 구매하기", dueDate: Date().addingTimeInterval(192500.0)),
        Reminder(title: "리터락커 비우기", dueDate: Date().addingTimeInterval(92500.0), repeatCycle: "매주"),
    ]
}
#endif
