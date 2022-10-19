//
//  ProductViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/10/17.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ProductViewController: UICollectionViewController {
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
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()
    let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
    
    init(product: ProductInfo, onChange: @escaping (ProductInfo) -> Void) {
        print("편집 페이지 입니다. \(product)")
        self.product = product
        self.workingProduct = product
        self.onChange = onChange
        self.imageURL = product.image
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        navigationItem.title = NSLocalizedString("편집하기", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDoneEdit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        
        updateSnapshotForEditing()
    }
    
    @objc func didDoneEdit() {
        if self.product.image != self.imageURL {
            self.imageUpload(uid: uid, productId: product.id, imageData: imageData) { url in
                self.product = self.workingProduct
                self.product.image = url
                self.updateSnapshotForEditing()
                self.updateProduct(self.product)
            }
        } else {
            self.product = self.workingProduct
            self.product.image = self.imageURL
            self.updateSnapshotForEditing()
            self.updateProduct(self.product)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.image, .editImage(let url)):
            cell.contentConfiguration = imageConfiguration(for: cell, with: url)
        case (.name, .editName(let name)):
            cell.contentConfiguration = nameConfiguration(for: cell, with: name!)
        case (.location, .editLocation(let location)):
            cell.contentConfiguration = locationConfiguration(for: cell, with: location)
        case (.notes, .editNote(let memo)):
            cell.contentConfiguration = noteConfiguration(for: cell, with: memo)
        case (.date, .editDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        default:
            fatalError("Unexpected combination of section and row.")
        }
    }
    
    @objc func didCancelEdit() {
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
    
    func updateProduct(_ productInfo: ProductInfo) {
//        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        let object = ProductInfo(id: productInfo.id, image: productInfo.image, name: productInfo.name, expirationDate: productInfo.expirationDate, storedMethod: productInfo.storedMethod, memo: productInfo.memo)
        self.ref.child("ProductInfo").child(productInfo.id).updateChildValues(object.toDictionary)
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
            print("이미지를 받아옵니다")
            let imageData = image.jpegData(compressionQuality: 0.1)!
            self.imageData = imageData
            
            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            let imageName = imageUrl?.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imageName!)
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            
            self.product.image = localPath!
            self.updateSnapshotForEditing()
        }
        self.dismiss(animated: true)
    }
    
    func imageUpload(uid: String, productId: String, imageData: Data, completion: @escaping (String) -> Void) {
        let imageRef = self.storage.child(uid).child("ProductImage")
        let imageName = "\(productId).jpg"
        let imagefileRef = imageRef.child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imagefileRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("이미지 올리기 실패! \(error)")
            } else {
                imagefileRef.downloadURL { url, error in
                    if let error = error {
                        print("이미지 다운로드 실패! \(error)")
                    } else {
                        guard let url = url else { return }
                        completion("\(url)")
                    }
                }
            }
        }
    }
}
