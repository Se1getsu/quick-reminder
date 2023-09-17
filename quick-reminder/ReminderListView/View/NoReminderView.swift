//
//  NoReminderView.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/15.
//

import UIKit

final class NoReminderView: UIView {

    private let label: UILabel = {
        var label = UILabel()
        label.text = "画面右上の「＋」ボタンを押して\n新規リマインダーを作成します。"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = R.color.noReminderViewText()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.noReminderViewBackground()
        
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
