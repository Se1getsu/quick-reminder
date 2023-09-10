//
//  ReminderListViewController.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/06.
//

import UIKit

class ReminderListViewController: UIViewController {
    
    private let reminderList = ReminderList()
    private let reminderListView = ReminderListView()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登録中のリマインダー"
        
        setupNavigationBar()
        view = reminderListView
        
        reminderListView.reminderTableView.dataSource = self
        reminderListView.reminderTableView.delegate = self
        
        reminderList.notificationCenter.addObserver(
            forName: .init("newReminder"),
            object: nil,
            queue: nil,
            using: { [unowned self] _ in
                self.reloadTableView()
            })
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        reminderList.addReminder(title: "test", date: Date())
    }
    
    func reloadTableView() {
        reminderListView.reminderTableView.reloadData()
    }

}

extension ReminderListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderList.getLength()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let reminder = reminderList.getReminder(index: indexPath.row)
        let title = reminder.title
        let dateText = dateFormatter.string(from: reminder.date)
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = title
            content.secondaryText = dateText
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ReminderEditViewController()
        vc.setup(reminder: reminderList.getReminder(index: indexPath.row))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [unowned self] (action, view, completionHandler) in
            self.reminderList.deleteReminder(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
