//
//  ReminderEditViewController.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/10.
//

import UIKit

/// リマインダーの編集結果に対して処理を行うメソッド。
protocol ReminderEditDelegate: AnyObject {
    func createReminder(_ reminder: Reminder)
    func didEditReminder(editedReminder: Reminder)
}

final class ReminderEditViewController: UIViewController {
    
    enum EditMode {
        /// リマインダーを新規作成するための編集モード。
        case create
        /// 既存のリマインダーを更新するための編集モード。
        case update
    }
    
    /// リマインダー編集画面のデリゲートとして動作するオブジェクト。
    weak var delegate: ReminderEditDelegate?
    
    private var reminderEditView = ReminderEditView()
    
    private var reminder: Reminder!
    private var editMode: EditMode!
    private var notificationDateCalculator: NotificationDateCalculator!
    
    init(notificationDateCalculator: NotificationDateCalculator) {
        self.notificationDateCalculator = notificationDateCalculator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// リマインダー編集に必要な情報をセットアップする。
    ///
    /// - parameter reminder: 編集対象のリマインダー。
    /// - parameter editMode: 編集モード。
    func setup(reminder: Reminder, editMode: EditMode) {
        self.reminder = reminder
        self.editMode = editMode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = {
            switch editMode! {
            case .create:   return "新規作成"
            case .update:   return "編集"
            }
        }()
        view = reminderEditView
        setupNavigationBar()
        
        reminderEditView.titleTextField.placeholder = Reminder.defaultTitle
        reminderEditView.titleTextField.text = reminder.title == Reminder.defaultTitle ? "" : reminder.title
        reminderEditView.datePicker.date = reminder.date
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = {
            let barButton = UIBarButtonItem(
                title: "保存",
                style: .done,
                target: self,
                action: #selector(doneButtonTapped))
            barButton.accessibilityIdentifier = "Reminder Edit Save Button"
            return barButton
        }()
        navigationItem.leftBarButtonItem = {
            let barButton = UIBarButtonItem(
                title: "キャンセル",
                style: .plain,
                target: self,
                action: #selector(cancelButtonTapped))
            barButton.accessibilityIdentifier = "Reminder Edit Cancel Button"
            return barButton
        }()
    }
    
    /// ナビゲーションバーのキャンセルボタンがタップされた時の処理。
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    /// ナビゲーションバーの保存ボタンがタップされた時の処理。
    @objc func doneButtonTapped() {
        var title = Reminder.defaultTitle
        if let text = reminderEditView.titleTextField.text, !text.isEmpty {
            title = text
        }
        let time = reminderEditView.datePicker.date
        let date = notificationDateCalculator.calculate(from: time)
        
        let newReminder = reminder.reinit(title: title, date: date)
        switch editMode! {
        case .create:   delegate?.createReminder(newReminder)
        case .update:   delegate?.didEditReminder(editedReminder: newReminder)
        }
        dismiss(animated: true)
    }

}
