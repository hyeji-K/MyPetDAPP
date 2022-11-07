//
//  LocalNotifications.swift
//  MyPetD
//
//  Created by heyji on 2022/11/04.
//

import UIKit
import UserNotifications

class LocalNotifications {
    static let shared = LocalNotifications()
    
    func sendNotification(reminder: Reminder) {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = "MyPetD"
        notiContent.body = reminder.title
        notiContent.sound = UNNotificationSound.defaultCritical
//        notiContent.userInfo = ["index": 2]
//        notiContent.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let date = reminder.dueDate.dateLong!
        
        switch reminder.repeatCycle {
        case "반복없음":
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: reminder.id, content: notiContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
        case "매일":
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: reminder.id, content: notiContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
        case "매주":
            let dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: reminder.id, content: notiContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
        case "매월":
            // 28, 29, 30, 31 일때 만약 30일 반복이면?
            // 현재는 30일을 더하게 되어 있음
            let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: reminder.id, content: notiContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
        case "매년":
            let dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: reminder.id, content: notiContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
        default:
            break
        }
        print("알림 테스트입니다.")
    }
    
    func editNotification(reminder: Reminder) {
        // 알림 식별자로 검색 후 삭제
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id])
        
        self.sendNotification(reminder: reminder)
    }
    
    func removeNotification(id: Reminder.ID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
