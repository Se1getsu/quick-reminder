//
//  ReminderEditViewController.swift
//  quick-reminder
//  
//  Created by Seigetsu on 2023/10/03
//  
//

import UIKit

class ReminderEditViewController: UIViewController {
    private let titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = String(localized: "Reminder message")
        return titleLabel
    }()
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.accessibilityIdentifier = "Reminder Title Text Field"
        titleTextField.borderStyle = .roundedRect
        titleTextField.backgroundColor = UIColor(resource: .textFieldBackground)
        return titleTextField
    }()
    
    private let dateLabel: UILabel = {
        var dateLabel = UILabel()
        dateLabel.text = String(localized: "Notification time")
        return dateLabel
    }()
    
    private var saveBarButton: UIBarButtonItem?
    private var cancelBarButton: UIBarButtonItem?
    
    /// リマインダーの通知時刻を設定するためのUI。
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.accessibilityIdentifier = "Reminder Time Date Picker"
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    private var presenter: ReminderEditPresenterInput!
    
    func inject(presenter: ReminderEditPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .reminderEditViewBackground)
        setUpNavigationBar()
        presenter.viewDidLoad()
        
        titleTextField.placeholder = presenter.reminderTitlePlaceHodler
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        
        let safeArea = view.safeAreaLayoutGuide
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
    
    /// ナビゲーションバーのセットアップ処理。
    private func setUpNavigationBar() {
        saveBarButton = UIBarButtonItem(
            title: String(localized: "Save"),
            style: .done,
            target: self,
            action: #selector(saveButtonTapped))
        saveBarButton?.accessibilityIdentifier = "Reminder Edit Save Button"
        
        cancelBarButton = UIBarButtonItem(
            title: String(localized: "Cancel"),
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped(_:)))
        cancelBarButton?.accessibilityIdentifier = "Reminder Edit Cancel Button"
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    /// 編集キャンセルのボタンがタップされた時の処理。
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        presenter.cancelButtonTapped(
            title: titleTextField.text ?? "",
            date: datePicker.date
        )
    }
    
    /// 編集保存のボタンがタップされた時の処理。
    @objc func saveButtonTapped() {
        presenter.saveButtonTapped(
            title: titleTextField.text ?? "",
            date: datePicker.date
        )
    }
}

extension ReminderEditViewController: ReminderEditPresenterOutput {
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func dismissView() {
        dismiss(animated: true)
    }
    
    func setUpReminderOnView(title: String, date: Date) {
        titleTextField.text = title
        datePicker.date = date
    }
    
    func showCancelAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = cancelBarButton
        
        let delete = UIAlertAction(title: String(localized: "Discard changes"), style: .destructive) { _ in
            self.presenter.discardButtonOnCancelAlertTapped()
        }
        delete.accessibilityIdentifier = "Reminder Edit Discard Button"
        
        let cancel = UIAlertAction(title: String(localized: "Continue editing"), style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
