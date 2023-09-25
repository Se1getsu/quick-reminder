//
//  ReminderListView.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/08.
//

import UIKit

final class ReminderListView: UIView {
    /// リマインダーリストを表示するためのテーブルビュー。
    let reminderTableView: UITableView = {
        let reminderTableView = UITableView()
        reminderTableView.accessibilityIdentifier = "Reminder List Table View"
        reminderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        reminderTableView.backgroundColor = R.color.reminderListTableViewBackground()
        return reminderTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.reminderListTableViewBackground()
        
        reminderTableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(reminderTableView)
        
        NSLayoutConstraint.activate([
            reminderTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reminderTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            reminderTableView.topAnchor.constraint(equalTo: topAnchor),
            reminderTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
