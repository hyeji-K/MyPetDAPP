//
//  AddProductViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import UIKit

class AddProductViewController: UIViewController {
    
    let productImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        print("save button tapped")
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
        navigationBar.backgroundColor = .systemMint
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = .black
        navigationBar.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let saveButton = UIButton()
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        navigationBar.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
//        let productImageView = UIImageView()
        self.view.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(100)
        }
        productImageView.backgroundColor = .systemMint
        productImageView.layer.cornerRadius = 10
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .scaleAspectFill
        
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
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.borderColor = UIColor.systemMint.cgColor
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        
//        let removeButton = UIButton()
//        productImageView.addSubview(removeButton)
//        removeButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(8)
//            make.right.equalToSuperview().inset(8)
//            make.height.width.equalTo(25)
//        }
//        removeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
//        removeButton.tintColor = .black
//        removeButton.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
//        removeButton.addTarget(self, action: #selector(removeImageButtonTapped), for: .touchUpInside)
        
        let productNameTextField = UITextField()
        self.view.addSubview(productNameTextField)
        productNameTextField.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        productNameTextField.borderStyle = .none
        productNameTextField.placeholder = "상품명을 입력하세요."
        
        let lineView = UIView()
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(productNameTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        lineView.backgroundColor = .systemMint
        
        let storedMethodTextField = UITextField()
        self.view.addSubview(storedMethodTextField)
        storedMethodTextField.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        storedMethodTextField.borderStyle = .none
        storedMethodTextField.placeholder = "보관장소를 입력하세요.(예: 냉장고/서랍)"
        
        let storedMethodlineView = UIView()
        self.view.addSubview(storedMethodlineView)
        storedMethodlineView.snp.makeConstraints { make in
            make.top.equalTo(storedMethodTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        storedMethodlineView.backgroundColor = .systemMint
        
        let memoTextField = UITextField()
        self.view.addSubview(memoTextField)
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(storedMethodlineView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        storedMethodTextField.borderStyle = .none
        memoTextField.placeholder = "한줄 메모를 입력하세요."
        
        let memolineView = UIView()
        self.view.addSubview(memolineView)
        memolineView.snp.makeConstraints { make in
            make.top.equalTo(memoTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        memolineView.backgroundColor = .systemMint
        
        let expirationLabel = UILabel()
        expirationLabel.text = "유효기한"
        self.view.addSubview(expirationLabel)
        expirationLabel.snp.makeConstraints { make in
            make.top.equalTo(memolineView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(16)
        }
        
        let expirationDatePicker = UIDatePicker()
        self.view.addSubview(expirationDatePicker)
        expirationDatePicker.snp.makeConstraints { make in
            make.top.equalTo(expirationLabel.snp.top)
            make.left.equalTo(expirationLabel.snp.right).inset(10)
            make.right.equalToSuperview().inset(16)
        }
//        expirationDatePicker.datePickerStyle = .inline
        expirationDatePicker.datePickerMode = .date
        expirationDatePicker.locale = Locale(identifier: "ko_KR")
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
//                self.alert("사용할 수 없는 타입입니다.")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let rawVal = UIImagePickerController.InfoKey.originalImage.rawValue
        if let img = info[UIImagePickerController.InfoKey(rawValue: rawVal)] as? UIImage {
            self.productImageView.image = img
        }
        self.dismiss(animated: true)
    }
}
