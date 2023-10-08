//
//  ReminderEditViewController.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/10.
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
        case create(defaultReminder: Reminder)
        /// 既存のリマインダーを更新するための編集モード。
        case update(currentReminder: Reminder)
        
        /// セットされているリマインダー。
        var reminder: Reminder {
            switch self {
            case .create(defaultReminder: let defaultReminder): return defaultReminder
            case .update(currentReminder: let currentReminder): return currentReminder
            }
        }
        
        /// ナビゲーションバーのタイトル。
        var title: String {
            switch self {
            case .create:   return "新規作成"
            case .update:   return "編集"
            }
        }
        
        /// キャンセル時のアラートメッセージ。
        var cancelAlertMessage: String {
            switch self {
            case .create:   return "この新規リマインダーを破棄しますか？"
            case .update:   return "この変更を破棄しますか？"
            }
        }
    }
    
    /// リマインダー編集画面のデリゲートとして動作するオブジェクト。
    weak var delegate: ReminderEditDelegate?
    
    private var reminderEditView = ReminderEditView()
    
    private var editMode: EditMode!
    private var notificationDateCalculator: NotificationDateCalculator!
    
    struct Dependency {
        let notificationDateCalculator: NotificationDateCalculator
    }
    
    /// - parameter editMode: 編集モード。
    init(dependency: Dependency, editMode: EditMode) {
        self.editMode = editMode
        self.notificationDateCalculator = dependency.notificationDateCalculator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = editMode.title
        view = reminderEditView
        setupNavigationBar()
        
        reminderEditView.titleTextField.placeholder = Reminder.defaultTitle
        setUpReminderOnView()
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
                action: #selector(cancelButtonTapped(_:)))
            barButton.accessibilityIdentifier = "Reminder Edit Cancel Button"
            return barButton
        }()
    }
    
    /// リマインダーの情報をビューにセットアップする処理。
    private func setUpReminderOnView() {
        let reminder = editMode.reminder
        reminderEditView.titleTextField.text = reminder.title == Reminder.defaultTitle ? "" : reminder.title
        reminderEditView.datePicker.date = reminder.date
    }
    
    /// ビューがセットアップされてから変更されたかを返す。
    private func didChangeReminderOnView() -> Bool {
        let reminder = editMode.reminder
        
        // タイトル
        var title = Reminder.defaultTitle
        if let text = reminderEditView.titleTextField.text, !text.isEmpty {
            title = text
        }
        if title != reminder.title { return true }
        
        // 通知時間
        let originalTime = reminder.date
        let editedTime = reminderEditView.datePicker.date
        let calendar = Calendar.current
        let originalComponents = calendar.dateComponents([.hour, .minute], from: originalTime)
        let editedComponents = calendar.dateComponents([.hour, .minute], from: editedTime)
        if originalComponents != editedComponents { return true }
        
        return false
    }
    
    /// ナビゲーションバーのキャンセルボタンがタップされた時の処理。
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if !didChangeReminderOnView() {
            discardChanges()
            return
        }
        
        let alert = UIAlertController(title: editMode.cancelAlertMessage, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = sender
        
        let delete = UIAlertAction(title: "変更内容を破棄", style: .destructive) { _ in self.discardChanges() }
        delete.accessibilityIdentifier = "Reminder Edit Discard Button"
        let cancel = UIAlertAction(title: "編集を続ける", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    /// 「変更内容を破棄」ボタンがタップされた時の処理。
    private func discardChanges() {
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
        
        let newReminder = editMode.reminder.reinit(title: title, date: date)
        switch editMode! {
        case .create:   delegate?.createReminder(newReminder)
        case .update:   delegate?.didEditReminder(editedReminder: newReminder)
        }
        dismiss(animated: true)
    }
}
