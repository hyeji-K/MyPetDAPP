//
//  AppDelegate.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 파이어베이스 초기화
        FirebaseApp.configure()
        // 파이어베이스 익명 인증
        Auth.auth().signInAnonymously { authResult, error in
            DispatchQueue.main.async {
                guard let user = authResult?.user else { return }
                let _ = user.isAnonymous  // isAnonymous = true
                let uid = user.uid
                UserDefaults.standard.set(uid, forKey: "firebaseUid")
                print("FirebaseAuth: \(uid)")
                print("UserDefaults \(UserDefaults.standard.string(forKey: "firebaseUid")!)")
            }
        }
        
        // 네비게이션바 속성 설정
        UINavigationBar.appearance().tintColor = .tintColor
        UINavigationBar.appearance().backgroundColor = .secondarySystemBackground
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        // 로컬 푸시 알림 설정
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.delegate = self
        // 알림 동의
        notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { didAllow, error in
            if didAllow {
                print("알림이 허용되었습니다.")
//                UserDefaults.standard.set(didAllow, forKey: "notiSwitch")
//                print(UserDefaults.standard.bool(forKey: "notiSwitch"))
            } else {
                print("알림이 허용되지 않았습니다.")
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 실행 도중에 알림 메시지가 도착한 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 알림 배너 띄워주기
        completionHandler([.banner, .badge, .sound])
    }
    
    // 사용자가 알림 메시지를 클릭했을 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 앱 열어서 해당 탭으로 이동
        NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["index": 2])
        
        completionHandler()
    }
}
