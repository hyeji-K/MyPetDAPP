//
//  Networking.swift
//  MyPetD
//
//  Created by heyji on 3/5/25.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class Networking {
    static let shared = Networking()
    
    var ref: DatabaseReference!
    let storage = FirebaseStorage.Storage.storage().reference()
    lazy var uid = UserDefaults.standard.string(forKey: "firebaseUid")
    
    enum Classification: String {
        case user = "User"
        case pets = "Pets"
        case products = "Products"
        case reminders = "Reminders"
        case completeReminders = "CompleteReminders"
    }
    
    enum StorageName: String {
        case petImage = "PetImage"
        case productImage = "ProductImage"
    }
    
    // MARK: [Read]
    func readDataList(classification: Classification, completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference().child("Users").child(uid)
        self.ref.child(classification.rawValue).observe(.value) { snapshot in
            completion(snapshot)
        }
    }
    
    func readCompleteReminders(classification: Classification, completion: @escaping (DataSnapshot) -> Void) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference().child("Users").child(uid)
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
    
    // MARK: [Create]
    func createReminder(reminder: Reminder) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference().child("Users").child(uid)
        let date = reminder.dueDate.dateLong!.stringFormat
        let object = Reminder(id: reminder.id, title: reminder.title, dueDate: "\(date)", repeatCycle: reminder.repeatCycle, isComplete: reminder.isComplete)
        self.ref.child("Reminders").child(reminder.id).setValue(object.toDictionary)
    }
    
    // MARK: [Update]
    func updatePet(petData: Pet, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference().child("Users").child(uid)
        let petObject = Pet(id: petData.id,
                          name: petData.name,
                          imageUrl: petData.imageUrl,
                          birthDate: petData.birthDate,
                          withDate: petData.withDate,
                          createdAt: petData.createdAt,
                          updateAt: Date().stringFormat)
        self.ref.child(classification.rawValue).child(petData.id).updateChildValues(petObject.toDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func updateProduct(productData: Product, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference().child("Users").child(uid)
        let productObject = Product(id: productData.id,
                                  name: productData.name,
                                  expirationDate: productData.expirationDate,
                                  imageUrl: productData.imageUrl,
                                  storedMethod: productData.storedMethod,
                                  memo: productData.memo,
                                  catPreference: productData.catPreference,
                                  price: productData.price,
                                  category: productData.category,
                                  state: productData.state,
                                  createdAt: productData.createdAt,
                                  updateAt: Date().stringFormat)
        self.ref.child(classification.rawValue).child(productData.id).updateChildValues(productObject.toDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func updateReminder(reminderData: Reminder, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference().child("Users").child(uid)
        let reminderObject = Reminder(id: reminderData.id,
                              title: reminderData.title,
                              dueDate: reminderData.dueDate,
                              repeatCycle: reminderData.repeatCycle,
                              isComplete: reminderData.isComplete)
        self.ref.child(classification.rawValue).child(reminderData.id).updateChildValues(reminderObject.toDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func updateCompleteReminder(id: String, reminderData: Reminder, classification: Classification) {
        guard let uid = self.uid else { return }
        self.ref = Database.database().reference().child("Users").child(uid)
        let completeDate = reminderData.dueDate.dateLong!.stringFormatShortline
        self.ref.child(classification.rawValue).child(completeDate).child(id).setValue(reminderData.toDictionary) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    // MARK: [Delete]
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
        self.ref = Database.database().reference().child("Users").child(uid)
        if date == nil {
            self.ref.child(classification.rawValue).child(id).removeValue()
        } else {
            guard let date = date else { return }
            self.ref.child(classification.rawValue).child(date).child(id).removeValue()
        }
    }
}

