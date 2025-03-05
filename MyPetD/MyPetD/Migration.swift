//
//  Migration.swift
//  MyPetD
//
//  Created by heyji on 3/4/25.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

func checkAndMigrateIfNeeded() {
    guard let userId = Auth.auth().currentUser?.uid else {
        print("사용자 없음")
        return
    }
    
    let userRef = Database.database().reference().child("Users").child(userId)
    
    // 마이그레이션 여부 확인
    userRef.child("isMigrated").observeSingleEvent(of: .value) { snapshot in
        if let isMigrated = snapshot.value as? Bool, isMigrated {
            print("마이그레이션 완료")
            return
        } else {
            print("마이그레이션 시작")
            migrateRealtimeDatabaseIfNeeded()
        }
    }
}

func setupNewUserIfNeeded() {
    guard let userId = Auth.auth().currentUser?.uid else { return }
    
    let userRef = Database.database().reference().child("Users").child(userId)
    
    userRef.observeSingleEvent(of: .value) { snapshot in
        if snapshot.exists() {
            print("이미 있는 사용자")
        } else {
            let userInfoRef = userRef.child("User")
            let userInfoData: [String: Any] = [
                "createdAt": Date().stringFormat,
                "lastActiveAt": Date().stringFormat
            ]
            userInfoRef.setValue(userInfoData)
        }
        userRef.child("isMigrated").setValue(true)
    }
}

func migrateRealtimeDatabaseIfNeeded() {
    guard let userId = Auth.auth().currentUser?.uid else { return }
    
    let creationDate = Auth.auth().currentUser?.metadata.creationDate ?? Date()
    
    let dbRef = Database.database().reference()
    let legacyUserRef = dbRef.child(userId) // 기존 데이터
    let userRef = dbRef.child("Users").child(userId) // 신규 데이터
    
    legacyUserRef.observeSingleEvent(of: .value) { snapshot in
        guard let userData = snapshot.value as? [String: Any] else { return }
        
        let userInfoRef = userRef.child("User")
        let userInfoData: [String: Any] = [
            "createdAt": creationDate.stringFormat,
            "lastActiveAt": Date().stringFormat
        ]
        userInfoRef.setValue(userInfoData)
        
        
        // Reminder 마이그레이션
        if let reminders = userData["Reminder"] as? [String: [String: Any]] {
            for (reminderId, reminderData) in reminders {
                let reminderRef = userRef.child("Reminders").child(reminderId)
                reminderRef.setValue(reminderData)
            }
        }
        
        // CompleteReminder 마이그레이션
        if let completeReminders = userData["CompleteReminder"] as? [String: [String: [String: Any]]] {
            for (date, reminders) in completeReminders {
                for (reminderId, reminderData) in reminders {
                    let completeReminderRef = userRef.child("completedReminders").child(date).child(reminderId)
                    completeReminderRef.setValue(reminderData)
                }
            }
        }
        
        // ProductInfo 마이그레이션
        if let products = userData["ProductInfo"] as? [String: [String: Any]] {
            for (productId, productData) in products {
                let productRef = userRef.child("Products").child(productId)
                
                let id = productId
                let name = productData["name"] as! String
                let expirationDate = productData["expirationDate"] as! String
                let imageUrl = productData["image"] as? String ?? ""
                let memo = productData["memo"] as? String ?? ""
                let storedMethod = productData["storedMethod"] as? String ?? ""
                
                let price: String = ""
                let catPreference: Int = 0
                let category: String = "기타"
                var state: String = "true"
                if expirationDate.dateLong! < Date() {
                    state = "false"
                }
                let createdAt: String = Date().stringFormat
                let updateAt: String = Date().stringFormat
                
                let newProductData: [String: Any] = [
                    "id": id,
                    "name": name,
                    "expirationDate": expirationDate,
                    "imageUrl": imageUrl,
                    "memo": memo,
                    "storedMethod": storedMethod,
                    "price": price,
                    "catPreference": catPreference,
                    "category": category,
                    "state": state,
                    "createdAt": createdAt,
                    "updateAt": updateAt
                ]
                productRef.setValue(newProductData)
            }
        }
        
        // PetInfo 마이그레이션
        if let pets = userData["PetInfo"] as? [String: [String: Any]] {
            for (petId, petData) in pets {
                let petRef = userRef.child("Pets").child(petId)
                
                let id = petId
                let name = petData["name"] as! String
                let imageUrl = petData["image"] as? String ?? ""
                let withDate = petData["withDate"] as! String
                let birthDate = petData["birthDate"] as! String
                let createdAt = petData["createdDate"] as! String
                let updateAt: String = Date().stringFormat
                
                let newPetData: [String: Any] = [
                    "id": id,
                    "name": name,
                    "imageUrl": imageUrl,
                    "withDate": withDate,
                    "birthDate": birthDate,
                    "createdAt": createdAt,
                    "updateAt": updateAt
                ]
                petRef.setValue(newPetData)
            }
        }
        
        userRef.child("isMigrated").setValue(true)
    }
}
