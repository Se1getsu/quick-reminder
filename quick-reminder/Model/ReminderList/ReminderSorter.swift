//
//  ReminderSorter.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/12.
//

import Foundation

/// ReminderListのソートのためのメソッド。
protocol ReminderSorterProtocol {
    /// 与えられたReminder配列をソートしたものを返す。
    func sorted(reminders: [Reminder]) -> [Reminder]
}

/// ReminderListのソートを行う。
struct ReminderSorter: ReminderSorterProtocol {
    func sorted(reminders: [Reminder]) -> [Reminder] {
        reminders.sorted { $0.date < $1.date }
    }
}
