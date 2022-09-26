//
//  AddPetViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/09/17.
//

import UIKit

class AddPetViewController: UIViewController {
    
    let petImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "반려동물 추가하기"
        
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
//        navigationBar.backgroundColor = .systemMint
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        navigationBar.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        closeButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let saveButton = UIButton()
        saveButton.setTitle("추가", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        navigationBar.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
//        let petImageView = UIImageView()
        self.view.addSubview(petImageView)
        petImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        petImageView.layer.borderColor = UIColor.systemGray.cgColor
        petImageView.layer.borderWidth = 1
        petImageView.layer.cornerRadius = 10
        petImageView.layer.masksToBounds = true
        petImageView.contentMode = .scaleAspectFill
        
        let addImageButton = UIButton()
        self.view.addSubview(addImageButton)
        addImageButton.snp.makeConstraints { make in
            make.center.equalTo(petImageView.snp.center)
            make.width.equalTo(petImageView.snp.width)
            make.height.equalTo(petImageView.snp.height)
        }
        addImageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        addImageButton.contentMode = .scaleAspectFill
        addImageButton.layer.cornerRadius = 10
        addImageButton.tintColor = .black
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        
        let productNameTextField = UITextField()
        self.view.addSubview(productNameTextField)
        productNameTextField.snp.makeConstraints { make in
            make.top.equalTo(petImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        productNameTextField.borderStyle = .none
        productNameTextField.placeholder = "반려동물 이름을 입력하세요."
        
        let lineView = UIView()
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(productNameTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        lineView.backgroundColor = .systemGray
        
        let birthLabel = UILabel()
        birthLabel.text = "생일"
        self.view.addSubview(birthLabel)
        birthLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(16)
        }
        
        let birthDatePicker = UIDatePicker()
        self.view.addSubview(birthDatePicker)
        birthDatePicker.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.top)
            make.left.equalTo(birthLabel.snp.right).inset(10)
            make.right.equalToSuperview().inset(16)
        }
//        expirationDatePicker.preferredDatePickerStyle = .wheels
        birthDatePicker.datePickerMode = .date
        // TODO: 핸드폰의 언어설정에 영향이 미치는지 확인해볼 것
        birthDatePicker.locale = Locale(identifier: "ko_KR")
        
        let withDayLabel = UILabel()
        withDayLabel.text = "만난 날"
        self.view.addSubview(withDayLabel)
        withDayLabel.snp.makeConstraints { make in
            make.top.equalTo(birthDatePicker.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(16)
        }
        
        let withDayDatePicker = UIDatePicker()
        self.view.addSubview(withDayDatePicker)
        withDayDatePicker.snp.makeConstraints { make in
            make.top.equalTo(withDayLabel.snp.top)
            make.left.equalTo(withDayLabel.snp.right).inset(10)
            make.right.equalToSuperview().inset(16)
        }
        withDayDatePicker.datePickerMode = .date
        withDayDatePicker.locale = Locale(identifier: "ko_KR")
    }
}

extension AddPetViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
            self.petImageView.image = img
        }
        self.dismiss(animated: true)
    }
}
