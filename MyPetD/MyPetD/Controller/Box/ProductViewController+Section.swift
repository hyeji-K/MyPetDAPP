//
//  ProductViewController+Section.swift
//  MyPetD
//
//  Created by heyji on 2022/10/17.
//

import UIKit

extension ProductViewController {
    enum Section: Int, Hashable {
        case image
        case name
        case location
        case notes
        case date
        
        var name: String {
            switch self {
            case .image:
                return NSLocalizedString("사진", comment: "Product Image section name")
            case .name:
                return NSLocalizedString("상품명", comment: "Product Name section name")
            case .location:
                return NSLocalizedString("보관장소", comment: "Location section name")
            case .notes:
                return NSLocalizedString("한줄 메모", comment: "Notes section name")
            case .date:
                return NSLocalizedString("유효기한", comment: "Date section name")
            }
        }
    }
}

