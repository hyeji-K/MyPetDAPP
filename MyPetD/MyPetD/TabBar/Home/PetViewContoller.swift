//
//  PetViewContoller.swift
//  MyPetD
//
//  Created by heyji on 2022/10/19.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class PetViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var petInfo: PetInfo {
        didSet {
            onChange(petInfo)
        }
    }
    var workingPetInfo: PetInfo
    var isAddingNewPetInfo = false
    var onChange: (PetInfo) -> Void
    let imageURL: String
    var imageData: Data = Data()
    
    private var dataSource: DataSource!
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()
    let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
    
    init(_ petInfo: PetInfo, onChange: @escaping (PetInfo) -> Void) {
        self.petInfo = petInfo
        self.workingPetInfo = petInfo
        self.onChange = onChange
        self.imageURL = petInfo.image
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        if isAddingNewPetInfo {
        } else {
            self.navigationItem.title = NSLocalizedString("편집하기", comment: "Pet view controller title")            
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDoneEdit))
        
        updateSnapshot()
    }
    
    @objc func didDoneEdit() {
        if self.petInfo.image != self.imageURL {
            self.imageUpload(uid: uid, petId: petInfo.id, imageData: imageData) { url in
                self.petInfo.image = url
                self.updateSnapshot()
                self.petInfo = self.workingPetInfo
                self.updatePetInfo(self.petInfo)
            }
        } else {
            self.petInfo.image = self.imageURL
            self.updateSnapshot()
            self.petInfo = self.workingPetInfo
            self.updatePetInfo(self.petInfo)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didCancelEdit() {
        self.petInfo.image = self.imageURL
        workingPetInfo = petInfo
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
            cell.contentConfiguration = nameConfiguration(for: cell, with: name)
        case (.birthDate, .editBirthDate(let birthDate)):
            cell.contentConfiguration = birthDateConfiguration(for: cell, with: birthDate)
        case (.withDate, .editWithDate(let withDate)):
            cell.contentConfiguration = withDateConfiguration(for: cell, with: withDate)
        default:
            fatalError("Unexpected combination of section and row.")
        }
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.image, .name, .birthDate, .withDate])
        snapshot.appendItems([.header(Section.image.name), .editImage(petInfo.image)], toSection: .image)
        snapshot.appendItems([.header(Section.name.name), .editName(petInfo.name)], toSection: .name)
        let birthDate = petInfo.birthDate.dateLong
        snapshot.appendItems([.header(Section.birthDate.name), .editBirthDate(birthDate!)], toSection: .birthDate)
        let withDate = petInfo.withDate.dateLong
        snapshot.appendItems([.header(Section.withDate.name), .editWithDate(withDate!)], toSection: .withDate)
        dataSource.apply(snapshot)
    }
    
    func updatePetInfo(_ petInfo: PetInfo) {
        self.ref = Database.database().reference(withPath: uid)
        let object = PetInfo(id: petInfo.id, image: petInfo.image, name: petInfo.name, birthDate: petInfo.birthDate, withDate: petInfo.withDate)
        self.ref.child("PetInfo").child(petInfo.id).updateChildValues(object.toDictionary)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}

extension PetViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
            
            self.petInfo.image = localPath!
            self.updateSnapshot()
        }
        self.dismiss(animated: true)
    }
    
    func imageUpload(uid: String, petId: String, imageData: Data, completion: @escaping (String) -> Void) {
        let imageRef = self.storage.child(uid).child("PetImage")
        let imageName = "\(petId).jpg"
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
