//
//  ProductViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/10/17.
//

import UIKit

final class ProductViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var product: ProductInfo {
        didSet {
            onChange(product)
        }
    }
    var workingProduct: ProductInfo
    var isAddingNewProduct = false
    var onChange: (ProductInfo) -> Void
    let imageURL: String
    var imageData: Data = Data()

    private var dataSource: DataSource!
    
    init(product: ProductInfo, onChange: @escaping (ProductInfo) -> Void) {
        self.product = product
        self.workingProduct = product
        self.onChange = onChange
        self.imageURL = product.image
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        listConfiguration.backgroundColor = .white
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        navigationItem.title = NSLocalizedString("편집하기", comment: "Reminder view controller title")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelEdit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(didDoneEdit))
        
        updateSnapshotForEditing()
    }
    
    @objc private func didDoneEdit() {
        if self.product.image != self.imageURL {
            NetworkService.shared.imageUpload(id: product.id, storageName: .productImage, imageData: imageData) { url in
                if self.workingProduct.name != "" {
                    self.product = self.workingProduct
                    self.product.image = url
                    self.updateSnapshotForEditing()
                    self.updateProduct(self.product)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.alert("상품명을 입력하세요.")
                }
            }
        } else {
            if self.workingProduct.name != "" {
                self.product = self.workingProduct
                self.product.image = self.imageURL
                self.updateSnapshotForEditing()
                self.updateProduct(self.product)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.alert("상품명을 입력하세요.")
            }
        }
    }
    
    private func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.image, .editImage(let url)):
            cell.contentConfiguration = imageConfiguration(for: cell, with: url)
        case (.name, .editName(let name)):
            cell.contentConfiguration = nameConfiguration(for: cell, with: name!)
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor.shadyLadyColor.cgColor
        case (.location, .editLocation(let location)):
            cell.contentConfiguration = locationConfiguration(for: cell, with: location)
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor.shadyLadyColor.cgColor
        case (.notes, .editNote(let memo)):
            cell.contentConfiguration = noteConfiguration(for: cell, with: memo)
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor.shadyLadyColor.cgColor
        case (.date, .editDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor.shadyLadyColor.cgColor
        default:
            fatalError("Unexpected combination of section and row.")
        }
    }
    
    @objc private func didCancelEdit() {
        self.product.image = self.imageURL
        workingProduct = product
        self.dismiss(animated: true, completion: nil)
    }
    
    private func prepareForEditing() {
        updateSnapshotForEditing()
    }
    
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.image, .name, .location, .notes, .date])
        snapshot.appendItems([.header(Section.image.name), .editImage(product.image)], toSection: .image)
        snapshot.appendItems([.header(Section.name.name), .editName(product.name)], toSection: .name)
        snapshot.appendItems([.header(Section.location.name), .editLocation(product.storedMethod)], toSection: .location)
        snapshot.appendItems([.header(Section.notes.name), .editNote(product.memo)], toSection: .notes)
        let date = product.expirationDate.dateLong
        snapshot.appendItems([.header(Section.date.name), .editDate(date!)], toSection: .date)
        dataSource.apply(snapshot)
    }
    
    private func updateProduct(_ productInfo: ProductInfo) {
        NetworkService.shared.updateProductInfo(productInfo: productInfo, classification: .productInfo)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}

extension ProductViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func addImageButtonTapped() {
        
        selectLibrary(src: .photoLibrary)
        
        func selectLibrary(src: UIImagePickerController.SourceType) {
            if UIImagePickerController.isSourceTypeAvailable(src) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                
                self.present(picker, animated: false)
            } else {
                self.alert("사용할 수 없는 타입입니다.")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let rawVal = UIImagePickerController.InfoKey.originalImage.rawValue
        if let image = info[UIImagePickerController.InfoKey(rawValue: rawVal)] as? UIImage {
            let imageData = image.jpegData(compressionQuality: 0.1)!
            self.imageData = imageData
            
            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            let imageName = imageUrl?.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let appendingPath = documentDirectory?.appending("/")
            let localPath = appendingPath?.appending(imageName!)
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            
            self.product.image = localPath!
            self.updateSnapshotForEditing()
        }
        self.dismiss(animated: true)
    }
}
