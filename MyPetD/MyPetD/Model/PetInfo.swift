//
//  PetInfo.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import Foundation

struct PetInfo: Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    var image: String
    var name: String
    var birthDate: String
    var withDate: String
    var createdDate: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id, "name": name, "image": image, "birthDate": birthDate, "withDate": withDate, "createdDate": createdDate]
        return dict
    }
}

extension Array where Element == PetInfo {
    func indexOfPet(with id: PetInfo.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

extension PetInfo {
    static let list = [
        PetInfo(id: "0", image: "testImage1", name: "뭉치", birthDate: "2018.01.01", withDate: "2018.03.17", createdDate: Date.now.stringFormat),
        PetInfo(id: "1", image: "testImage2", name: "삐용", birthDate: "2018.09.25", withDate: "2018.12.20", createdDate: Date.now.stringFormat),
    ]
}

class PetManager {
    var petInfos: [PetInfo] = []
    
}
