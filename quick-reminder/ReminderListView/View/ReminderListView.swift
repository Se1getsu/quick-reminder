//
//  ReminderListView.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/08.
//

import UIKit

class ReminderListView: UIView {
    
    /// リマインダーリストを表示するためのテーブルビュー。
    let reminderTableView: UITableView = {
        let reminderTableView = UITableView()
        reminderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return reminderTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
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