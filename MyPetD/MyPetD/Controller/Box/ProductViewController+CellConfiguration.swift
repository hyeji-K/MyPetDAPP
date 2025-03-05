//
//  ProductViewController+CellConfiguration.swift
//  MyPetD
//
//  Created by heyji on 2022/10/17.
//

import UIKit

extension ProductViewController {
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
            self?.workingProduct.imageUrl = image
        }
        return contentConfiguration
    }
    
    func nameConfiguration(for cell: UICollectionViewListCell, with name: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = name
        contentConfiguration.onChange = { [weak self] name in
            self?.workingProduct.name = name
        }
        return contentConfiguration
    }
    
    func locationConfiguration(for cell: UICollectionViewListCell, with location: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = location
        contentConfiguration.onChange = { [weak self] location in
            self?.workingProduct.storedMethod = location
        }
        return contentConfiguration
    }
    
    func noteConfiguration(for cell: UICollectionViewListCell, with note: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = note
        contentConfiguration.onChange = { [weak self] memo in
            self?.workingProduct.memo = memo
        }
        return contentConfiguration
    }
    
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentView.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = date
        contentConfiguration.onChange = { [weak self] dueDate in
            self?.workingProduct.expirationDate = dueDate
        }
        return contentConfiguration
    }
}
