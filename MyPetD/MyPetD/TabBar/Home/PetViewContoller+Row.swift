//
//  PetViewContoller+Row.swift
//  MyPetD
//
//  Created by heyji on 2022/10/19.
//

import UIKit

extension PetViewController {
    enum Row: Hashable {
        case header(String)
        case viewImage
        case viewName
        case viewBirthDate
        case viewWithDate
        case editImage(String?)
        case editName(String?)
        case editBirthDate(Date)
        case editWithDate(Date)
    }
}
