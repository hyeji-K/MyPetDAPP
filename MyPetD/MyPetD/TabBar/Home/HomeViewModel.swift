//
//  HomeViewModel.swift
//  MyPetD
//
//  Created by heyji on 2022/10/04.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

class HomeViewModel {
    
    @Published var petInfos: [PetInfo] = []
    var subscriptions = Set<AnyCancellable>()
    
    var ref: DatabaseReference!
    
    func fetch() {
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            if UserDefaults.standard.string(forKey: "firebaseUid") == nil {
                UserDefaults.standard.set(uid, forKey: "firebaseUid")
            }
        }
        
        // 파이어베이스에서 데이터 읽기
        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        DispatchQueue.global().async {
            self.ref.child("PetInfo").observe(.value) { snapshot in
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let petInfo: [PetInfo] = try decoder.decode([PetInfo].self, from: data)
                    self.petInfos = petInfo
                } catch let error {
                    print(error.localizedDescription)
                }
            }            
        }
    }
}
