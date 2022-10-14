//
//  BoxViewModel.swift
//  MyPetD
//
//  Created by heyji on 2022/10/06.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

class BoxViewModel {
    
    @Published var productInfos: [ProductInfo] = []
    var subscriptions = Set<AnyCancellable>()
    
    var ref: DatabaseReference!
    
    func fetch() {
        // 파이어베이스에서 데이터 읽기
        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        DispatchQueue.global().async {
            self.ref.child("ProductInfo").observe(.value) { snapshot in
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let productInfo: [ProductInfo] = try decoder.decode([ProductInfo].self, from: data)
                    self.productInfos = productInfo
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
