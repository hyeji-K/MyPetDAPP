//
//  Pet.swift
//  MyPetD
//
//  Created by heyji on 3/5/25.
//

import Foundation

struct Pet: Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var imageUrl: String
    var birthDate: String
    var withDate: String
    let createdAt: String
    var updateAt: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id,
                                   "name": name,
                                   "imageUrl": imageUrl,
                                   "birthDate": birthDate,
                                   "withDate": withDate,
                                   "createdAt": createdAt,
                                   "updateAt": updateAt]
        return dict
    }
}
