//
//  ProductViewController+Row.swift
//  MyPetD
//
//  Created by heyji on 2022/10/17.
//

import UIKit

extension ProductViewController {
    enum Row: Hashable {
        case header(String)
        case viewImage
        case viewName
        case viewLocation
        case viewNotes
        case viewDate
        case editImage(String?)
        case editName(String?)
        case editLocation(String?)
        case editNote(String?)
        case editDate(Date)
    }
}
