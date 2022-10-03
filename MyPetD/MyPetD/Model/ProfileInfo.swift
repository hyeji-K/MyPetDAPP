//
//  ProfileInfo.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import Foundation

struct ProfileInfo: Hashable, Identifiable, Codable {
    let id: String
    let image: String
    let name: String
    let birthDate: String
    let withDate: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id, "name": name, "image": image, "birthDate": birthDate, "withDate": withDate]
        return dict
    }
}

extension ProfileInfo {
    static let list = [
        ProfileInfo(id: "0", image: "testImage1", name: "뭉치", birthDate: "2018.01.01", withDate: "2018.03.17"),
        ProfileInfo(id: "1", image: "testImage2", name: "삐용", birthDate: "2018.09.25", withDate: "2018.12.20"),
    ]
}
