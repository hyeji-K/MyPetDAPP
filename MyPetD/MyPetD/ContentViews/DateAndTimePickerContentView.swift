//
//  DateAndTimePickerContentView.swift
//  MyPetD
//
//  Created by heyji on 2022/10/18.
//

import UIKit

class DateAndTimePickerContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        var onChange: (String) -> Void = { _ in }

        func makeContentView() -> UIView & UIContentView {
            return DateAndTimePickerContentView(self)
        }
    }
    
    let datePicker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minuteInterval = 5
        datePicker.datePickerMode = .dateAndTime
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.date
    }
    
    @objc private func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DateAndTimePickerContentView.Configuration else { return }
        let stringToDate = sender.date.stringFormat
        configuration.onChange(stringToDate)
    }
}

extension UICollectionViewListCell {
    func dateAndTimePickerConfiguration() -> DateAndTimePickerContentView.Configuration {
        DateAndTimePickerContentView.Configuration()
    }
}
