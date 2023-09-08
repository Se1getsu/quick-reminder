//
//  ReminderListViewController.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/06.
//

import UIKit

class ReminderListViewController: UIViewController {
    
    private let reminderRepository = ReminderRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登録中のリマインダー"
        view = ReminderListView()
    }

}
