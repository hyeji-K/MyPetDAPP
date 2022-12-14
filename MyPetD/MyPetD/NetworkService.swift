//
//  NetworkService.swift
//  MyPetD
//
//  Created by heyji on 2022/10/26.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class NetworkService {
    static let shared = NetworkService()
    
    var ref: DatabaseReference!
    let storage = FirebaseStorage.Storage.storage().reference()
    lazy var uid = UserDefaults.standard.string(forKey: "firebaseUid")
    
    enum Classification: String {
        case petInfo = "PetInfo"
        case productInfo = "ProductInfo"
        case reminder = "Reminder"
        case completeReminder = "CompleteReminder"
    }
    
    enum StorageName: String {
        case petImage = "PetImage"
        case productImage = "ProductImage"
    }
    
    func getDataList(classification: Classification, completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference(withPath: uid)
        self.ref.child(classification.rawValue).observe(.value) { snapshot in
            completion(snapshot)
        }
    }
    
    func getCompleteRemindersList(classification: Classification, completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference(withPath: uid)
        let date = Date.now.stringFormatShortline
        self.ref.child(classification.rawValue).child(date).observe(.value) { snapshot in
            completion(snapshot)
        }
    }
    
    func imageUpload(id: String, storageName: StorageName, imageData: Data, completion: @escaping (String) -> Void) {
        guard let uid = self.uid else { return }
        let imageRef = self.storage.child(uid).child(storageName.rawValue)
        let imageName = "\(id).jpg"
        let imagefileRef = imageRef.child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imagefileRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("이미지 올리기 실패! \(error)")
            } else {
                imagefileRef.downloadURL { url, error in
                    if let error = error {
                        print("이미지 다운로드 실패! \(error)")
                    } else {
                        guard let url = url else { return }
                        completion("\(url)")
                    }
                }
            }
        }
    }
    
    func postReminder(reminder: Reminder) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference(withPath: uid)
        let date = reminder.dueDate.dateLong!.stringFormat
        let object = Reminder(id: reminder.id, title: reminder.title, dueDate: "\(date)", repeatCycle: reminder.repeatCycle, isComplete: reminder.isComplete)
        self.ref.child("Reminder").child(reminder.id).setValue(object.toDictionary)
    }
    
    func updatePetInfo(petInfo: PetInfo, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference(withPath: uid)
        let object = PetInfo(id: petInfo.id, image: petInfo.image, name: petInfo.name, birthDate: petInfo.birthDate, withDate: petInfo.withDate, createdDate: petInfo.createdDate)
        self.ref.child(classification.rawValue).child(petInfo.id).updateChildValues(object.toDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func updateProductInfo(productInfo: ProductInfo, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference(withPath: uid)
        let object = ProductInfo(id: productInfo.id, image: productInfo.image, name: productInfo.name, expirationDate: productInfo.expirationDate, storedMethod: productInfo.storedMethod, memo: productInfo.memo)
        self.ref.child(classification.rawValue).child(productInfo.id).updateChildValues(object.toDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func updateReminder(reminder: Reminder, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference(withPath: uid)
        let object = Reminder(id: reminder.id, title: reminder.title, dueDate: reminder.dueDate, repeatCycle: reminder.repeatCycle, isComplete: reminder.isComplete)
        self.ref.child(classification.rawValue).child(reminder.id).updateChildValues(object.toDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func updateCompleteReminder(id: String, reminder: Reminder, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference(withPath: uid)
        let completeDate = reminder.dueDate.dateLong!.stringFormatShortline
        self.ref.child(classification.rawValue).child(completeDate).child(id).setValue(reminder.toDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func deleteImageAndData(with id: String, storageName: StorageName, classification: Classification) {
        guard let uid = self.uid else { return }
        
        let imageRef = storage.child(uid).child(storageName.rawValue)
        let imageName = "\(id).jpg"
        // 이미지가 있을 경우 삭제
        imageRef.listAll(completion: { result, error in
            if let error = error {
                print(error)
            }
            for item in result.items {
                if item.name == imageName {
                    imageRef.child(imageName).delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("삭제되었습니다.")
                        }
                    }
                }
            }
        })

        self.ref = Database.database().reference(withPath: uid)
        self.ref.child(classification.rawValue).child(id).removeValue()
    }
    
    func deleteData(with id: String, date: String? = nil, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference(withPath: uid)
        if date == nil {
            self.ref.child(classification.rawValue).child(id).removeValue()
        } else {
            guard let date = date else { return }
            self.ref.child(classification.rawValue).child(date).child(id).removeValue()
        }
    }
}
