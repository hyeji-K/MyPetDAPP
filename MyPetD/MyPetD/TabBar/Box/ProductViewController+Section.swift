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
                return NSLocalizedString("Product Image", comment: "Product Image section name")
            case .name:
                return NSLocalizedString("Product Name", comment: "Product Name section name")
            case .location:
                return NSLocalizedString("Location", comment: "Location section name")
            case .notes:
                return NSLocalizedString("Notes", comment: "Notes section name")
            case .date:
                return NSLocalizedString("Date", comment: "Date section name")
            }
        }
    }
}

