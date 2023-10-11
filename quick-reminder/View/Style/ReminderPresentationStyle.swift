//
//  ReminderPresentationStyle.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/10/10
//
//

import UIKit

/// リマインダーの表示スタイルを指定する定数。
enum ReminderPresentationStyle {
    /// 通知予定のリマインダーとして表示される。
    case normal
    /// 通知済みのリマインダーとして表示される。
    case notified
    
    /// セルの背景色。
    var backgroundColor: UIColor {
        switch self {
        case .normal:
            UIColor(resource: .activeReminderCellBackground)
        case .notified:
            UIColor(resource: .inactiveReminderCellBackground)
        }
    }
}
