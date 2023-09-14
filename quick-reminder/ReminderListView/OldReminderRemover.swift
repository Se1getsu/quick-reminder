//
//  OldReminderRemover.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/13.
//

import Foundation

/// ReminderListに含まれる古いリマインダーを削除するためのメソッド。
protocol OldReminderRemoverProtocol {
    func removeOldReminders(in reminderList: ReminderList)
}

/// ReminderListに含まれる、通知から12時間以上経過したリマインダーを削除する。
final class OldReminderRemover: OldReminderRemoverProtocol {
    
    let dateProvider: DateProviderProtocol!
    
    init(_ dateProvider: DateProviderProtocol) {
        self.dateProvider = dateProvider
    }
    
    /// ReminderListに含まれる、通知から12時間以上経過したリマインダーを削除する。
    func removeOldReminders(in reminderList: ReminderList) {
        reminderList.enumerated().filter { _, reminder in
            isReminderOld(reminder)
        }.reversed().forEach { index, _ in
            reminderList.deleteReminder(index: index)
        }
    }
    
    /// 与えられたReminderが通知から12時間以上経過しているかを判定する。
    private func isReminderOld(_ reminder: Reminder) -> Bool {
        let deadline = Calendar.current.date(byAdding: .hour, value: -12, to: dateProvider.now)!
        return reminder.date < deadline
    }
    
}
