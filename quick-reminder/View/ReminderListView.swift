//
//  ReminderListView.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/08.
//

import UIKit

class ReminderListView: UIView {
    
    private let reminderTableView: UITableView = {
        let reminderTableView = UITableView()
        reminderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return reminderTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemMint
        
        reminderTableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(reminderTableView)
        
        NSLayoutConstraint.activate([
            reminderTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reminderTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            reminderTableView.topAnchor.constraint(equalTo: topAnchor),
            reminderTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        reminderTableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReminderListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = "aaa"
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = "aaa"
        }
        return cell
    }
    
}
