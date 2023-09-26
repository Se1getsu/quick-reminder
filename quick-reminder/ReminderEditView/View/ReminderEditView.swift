//
//  ReminderEditView.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/10.
//

import UIKit

final class ReminderEditView: UIView {
    private let titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "内容"
        return titleLabel
    }()
    
    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.accessibilityIdentifier = "Reminder Title Text Field"
        titleTextField.borderStyle = .roundedRect
        titleTextField.backgroundColor = UIColor(resource: .textFieldBackground)
        return titleTextField
    }()
    
    private let dateLabel: UILabel = {
        var dateLabel = UILabel()
        dateLabel.text = "通知時刻"
        return dateLabel
    }()
    
    /// リマインダーの通知時刻を設定するためのUI。
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.accessibilityIdentifier = "Reminder Time Date Picker"
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.datePickerMode = .time
        return datePicker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(resource: .reminderEditViewBackground)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(titleTextField)
        addSubview(dateLabel)
        addSubview(datePicker)
        
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            titleTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            titleTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            titleTextField.heightAnchor.constraint(equalToConstant: 30),
            dateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25),
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30),
            datePicker.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            datePicker.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
