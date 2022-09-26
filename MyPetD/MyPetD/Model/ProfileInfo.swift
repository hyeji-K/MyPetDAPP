//
//  ProfileInfo.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import Foundation

struct ProfileInfo: Hashable, Identifiable, Codable {
    let id: Int
    let image: String
    let name: String
    let birthDate: String // Date
    let withDate: String // Date
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id, "image": image, "birthDate": birthDate, "withDate": withDate]
        return dict
    }
    
    static var id: Int = 0
}

extension ProfileInfo {
    static let list = [
        ProfileInfo(id: 1, image: "testImage1", name: "뭉치", birthDate: "2018.01.01", withDate: "2018.03.17"),
        ProfileInfo(id: 2, image: "testImage2", name: "삐용", birthDate: "2018.09.25", withDate: "2018.12.20"),
    ]
}
