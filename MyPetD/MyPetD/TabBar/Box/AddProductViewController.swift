//
//  AddProductViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddProductViewController: UIViewController {
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "상품명을 입력하세요."
        return textField
    }()
    let storedMethodTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "보관장소를 입력하세요.(예: 냉장고/서랍)"
        return textField
    }()
    let memoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "한줄 메모를 입력하세요."
        return textField
    }()
    let expirationDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()
    var imageData: Data?
    var imageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        print("save button tapped")
        
        guard let productName = productNameTextField.text else { return }
        guard let storedMethod = storedMethodTextField.text else { return }
        guard let memo = memoTextField.text else { return }
        let expirationDate = expirationDatePicker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let stringOfexpirationDate = formatter.string(from: expirationDate)
        
        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        guard let autoId = self.ref.child("PetInfo").childByAutoId().key else { return }
        
        // Storage에 이미지 Data 업로드 & URL 다운로드
        imageUpload(uid: uid, productName: productName) { url in
            print(url)
            let object = ProductInfo(id: autoId, imageOfProduct: url, nameOfProduct: productName, expirationDate: stringOfexpirationDate, storedMethod: storedMethod, memo: memo)
            
            self.ref.child("ProductInfo").child("\(object.id)").setValue(object.toDictionary)
        }
        
//        guard let imageUrl = self.imageUrl else { return }
//        let object = ProductInfo(id: autoId, imageOfProduct: imageUrl, nameOfProduct: productName, expirationDate: stringOfexpirationDate, storedMethod: storedMethod, memo: memo)
//
//        self.ref.child("ProductInfo").child("\(object.id)").setValue(object.toDictionary)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageUpload(uid: String, productName: String, completion: @escaping (String) -> Void) {
        let imageRef = self.storage.child(uid).child("ProductImage")
        let imageName = "\(productName).jpg"
        let imagefileRef = imageRef.child(imageName)
        guard let data = self.imageData else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imagefileRef.putData(data, metadata: metadata) { metadata, error in
            if let error = error {
                print(error)
            } else {
                imagefileRef.downloadURL { url, error in
                    if let error = error {
                        print(error)
                    } else {
                        guard let url = url else { return }
                        self.imageUrl = "\(url)"
                        completion("\(url)")
                    }
                }
            }
        }
    }
    
    @objc func removeImageButtonTapped() {
        print("remove image button tapped")
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.resignFirstResponder()
        
        let navigationBar = UINavigationBar()
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = .black
        navigationBar.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = "새로운 상품"
        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        let saveButton = UIButton()
        saveButton.setTitle("추가", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        navigationBar.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(100)
        }
        
        let addImageButton = UIButton()
        self.view.addSubview(addImageButton)
        addImageButton.snp.makeConstraints { make in
            make.center.equalTo(productImageView.snp.center)
            make.width.equalTo(productImageView.snp.width)
            make.height.equalTo(productImageView.snp.height)
        }
        addImageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        addImageButton.contentMode = .scaleAspectFill
        addImageButton.layer.cornerRadius = 10
        addImageButton.tintColor = .black
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(productNameTextField)
        productNameTextField.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        let lineView = UIView()
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(productNameTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        lineView.backgroundColor = .black
        
        self.view.addSubview(storedMethodTextField)
        storedMethodTextField.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        let storedMethodlineView = UIView()
        self.view.addSubview(storedMethodlineView)
        storedMethodlineView.snp.makeConstraints { make in
            make.top.equalTo(storedMethodTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        storedMethodlineView.backgroundColor = .black
        
        self.view.addSubview(memoTextField)
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(storedMethodlineView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        let memolineView = UIView()
        self.view.addSubview(memolineView)
        memolineView.snp.makeConstraints { make in
            make.top.equalTo(memoTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        memolineView.backgroundColor = .black
        
        let expirationLabel = UILabel()
        expirationLabel.text = "유효기한"
        self.view.addSubview(expirationLabel)
        expirationLabel.snp.makeConstraints { make in
            make.top.equalTo(memolineView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(16)
        }
        
        self.view.addSubview(expirationDatePicker)
        expirationDatePicker.snp.makeConstraints { make in
            make.top.equalTo(expirationLabel.snp.top)
            make.left.equalTo(expirationLabel.snp.right).inset(10)
            make.right.equalToSuperview().inset(16)
        }
    }
}

extension AddProductViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func addImageButtonTapped() {
        print("add image button tapped")
        
        selectLibrary(src: .photoLibrary)
        
        // 전달된 소스 타입에 맞게 이미지 피커 창을 여는 내부 함수
        func selectLibrary(src: UIImagePickerController.SourceType) {
            // 인자값을 검사하여 현재 사용 가능한 소스 타입인지를 처크한 다음, 만약 지원되지 않는 타입이라면 경고성 메시지를 출력
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
            self.productImageView.image = image
            self.imageData = image.jpegData(compressionQuality: 0.1)
        }
        self.dismiss(animated: true)
    }
}
