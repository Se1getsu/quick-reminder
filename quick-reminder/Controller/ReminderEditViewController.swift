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
    
    func setup(reminder: Reminder) {
        self.reminder = reminder
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "編集"
        view = reminderEditView
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "完了",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped))
    }
    
    @objc func doneButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
