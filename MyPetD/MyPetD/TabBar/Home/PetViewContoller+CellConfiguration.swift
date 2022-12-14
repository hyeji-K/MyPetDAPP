//
//  PetViewContoller+CellConfiguration.swift
//  MyPetD
//
//  Created by heyji on 2022/10/19.
//

import UIKit

extension PetViewController {
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
        contentConfiguration.textProperties.color = .black
        return contentConfiguration
    }
    
    func imageConfiguration(for cell: UICollectionViewListCell, with image: String?) -> ImageContentView.Configuration {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addImageButtonTapped))
        cell.addGestureRecognizer(gesture)
        var contentConfiguration = cell.imageConfiguration()
        contentConfiguration.image = image
        contentConfiguration.onChange = { [weak self] image in
            self?.workingPetInfo.image = image
        }
        return contentConfiguration
    }
    
    func nameConfiguration(for cell: UICollectionViewListCell, with name: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = name
        contentConfiguration.onChange = { [weak self] name in
            self?.workingPetInfo.name = name
        }
        return contentConfiguration
    }
    
    func birthDateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentView.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = date
        contentConfiguration.onChange = { [weak self] dueDate in
            self?.workingPetInfo.birthDate = dueDate
        }
        return contentConfiguration
    }
    
    func withDateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentView.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = date
        contentConfiguration.onChange = { [weak self] dueDate in
            self?.workingPetInfo.withDate = dueDate
        }
        return contentConfiguration
    }
}
