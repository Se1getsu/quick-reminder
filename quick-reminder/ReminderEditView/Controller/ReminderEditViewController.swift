//
//  ReminderEditViewController.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/10.
//

import UIKit

final class ReminderEditViewController: UIViewController {
    
    private var reminderEditView = ReminderEditView()
    
    private var reminder: Reminder!
    private var notificationDateCalculator: NotificationDateCalculator!
    
    init(_ notificationDateCalculator: NotificationDateCalculator) {
        self.notificationDateCalculator = notificationDateCalculator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(reminder: Reminder) {
        self.reminder = reminder
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "編集"
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
    }
    
    /// ナビゲーションバーの保存ボタンがタップされた時の処理。
    @objc func doneButtonTapped() {
        var title = Reminder.defaultTitle
        if let text = reminderEditView.titleTextField.text, !text.isEmpty {
            title = text
        }
        let time = reminderEditView.datePicker.date
        let date = notificationDateCalculator.calculate(from: time)
        
        let updatedReminder = reminder.reinit(title: title, date: date)
        let previousVC = navigationController?.viewControllers[(navigationController?.viewControllers.count)!-2] as? ReminderListViewController
        try? previousVC?.updateReminder(reminder: updatedReminder)
        navigationController?.popViewController(animated: true)
    }

}
