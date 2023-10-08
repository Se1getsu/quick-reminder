//
//  NoReminderView.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/15.
//

import UIKit

final class mvc_NoReminderView: UIView {
    private let label: UILabel = {
        var label = UILabel()
        label.accessibilityIdentifier = "No Reminder Description Label"
        label.text = "画面右上の「＋」ボタンを押して\n新規リマインダーを作成します。"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(resource: .noReminderViewText)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(resource: .noReminderViewBackground)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
