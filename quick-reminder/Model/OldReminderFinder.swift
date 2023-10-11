//
//  OldReminderFinder.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/13.
//

import Foundation

/// ReminderListに含まれる古いリマインダーを削除するためのメソッド。
protocol OldReminderFinderProtocol {
    /// ReminderListに含まれる、通知から12時間以上経過したリマインダーのインデックスを取得する。
    func getOldReminderIndices(in: ReminderListProtocol) -> [Int]
}

/// ReminderListに含まれる、通知から12時間以上経過したリマインダーを削除する。
struct OldReminderFinder: OldReminderFinderProtocol {
    let dateProvider: DateProviderProtocol!
    
    init(dateProvider: DateProviderProtocol) {
        self.dateProvider = dateProvider
    }
    
    func getOldReminderIndices(in reminderList: ReminderListProtocol) -> [Int] {
        reminderList.enumerated().filter { _, reminder in
            isReminderOld(reminder)
        }.map { index, _ in
            index
        }
    }
    
    /// 与えられたReminderが通知から12時間以上経過しているかを判定する。
    private func isReminderOld(_ reminder: Reminder) -> Bool {
        let deadline = Calendar.current.date(byAdding: .hour, value: -12, to: dateProvider.now)!
        return reminder.date <= deadline
    }
}
