//
//  ProfileInfo.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import Foundation

struct ProfileInfo: Hashable {
    let image: String
    let name: String
    let withDay: String
}

extension ProfileInfo {
    static let list = [
        ProfileInfo(image: "", name: "", withDay: ""),
        ProfileInfo(image: "testImage1", name: "뭉치", withDay: "1617"),
        ProfileInfo(image: "testImage2", name: "삐용", withDay: "1339"),
    ]
}
