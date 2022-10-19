//
//  PetViewContoller+Section.swift
//  MyPetD
//
//  Created by heyji on 2022/10/19.
//

import UIKit

extension PetViewController {
    enum Section: Int, Hashable {
        case image
        case name
        case birthDate
        case withDate
        
        var name: String {
            switch self {
            case .image:
                return NSLocalizedString("사진", comment: "Pet Image section name")
            case .name:
                return NSLocalizedString("이름", comment: "Pet Name section name")
            case .birthDate:
                return NSLocalizedString("생일", comment: "Pet BirthDay section name")
            case .withDate:
                return NSLocalizedString("만난날", comment: "Pet WithDay section name")
            }
        }
    }
}
