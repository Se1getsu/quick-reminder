//
//  ReminderListViewController.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/06.
//

import UIKit

class ReminderListViewController: UIViewController {
    
    private let reminderRepository = ReminderRepository.shared
    private var reminderList = ReminderList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登録中のリマインダー"
        
        view = {
            let reminderListView = ReminderListView()
            reminderListView.dataSource = self
            return reminderListView
        }()
    }

}

extension ReminderListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderList.getLength()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let text = reminderList.getReminder(index: indexPath.row).title
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = text
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = text
        }
        return cell
    }
    
}
