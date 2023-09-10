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
    private let notificationDateCalculator = NotificationDateCalculator.shared
    
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
    
    @objc func doneButtonTapped() {
        var title = Reminder.defaultTitle
        if let text = reminderEditView.titleTextField.text, !text.isEmpty {
            title = text
        }
        
        var date = reminderEditView.datePicker.date
        date = notificationDateCalculator.calculate(from: date)
        
        let newReminder = reminder.reinit(title: title, date: date)
        ReminderRepository.shared.updateReminder(newReminder)
        
        navigationController?.popViewController(animated: true)
    }

}
