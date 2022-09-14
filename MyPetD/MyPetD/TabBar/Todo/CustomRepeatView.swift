//
//  CustomRepeatView.swift
//  MyPetD
//
//  Created by heyji on 2022/09/14.
//

import UIKit

class CustomRepeatView: UIViewController {
    
    let customDate: [String] = ["일", "월"]
    var customDayDates: [Int] = []
    var customMonthDates: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        (1...31).forEach { int in
            customDayDates.append(int)
        }
        (1...12).forEach { int in
            customMonthDates.append(int)
        }
        
        let pickerView = UIPickerView()
        self.view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        pickerView.dataSource = self
        pickerView.delegate = self
    }
}

extension CustomRepeatView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return customDayDates.count
        } else {
            return customDate.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(customDayDates[row])"
        } else {
            return customDate[row]
        }
    }
    
}
