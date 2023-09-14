//
//  ReminderEditViewController.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/10.
//

import UIKit

class ReminderEditViewController: UIViewController {
    
    private var reminder: Reminder!
    private let reminderEditView = ReminderEditView()
    private let notificationDateCalculator = NotificationDateCalculator.shared!
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "完了",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped))
    }
    
    /// ナビゲーションバーの完了ボタンがタップされた時の処理。
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
