//
//  OldReminderRemover.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/13.
//

import Foundation

protocol OldReminderRemoverProtocol {
    func removeOldReminders(in reminderList: ReminderList)
}

final class OldReminderRemover: OldReminderRemoverProtocol {
    
    let dateProvider: DateProviderProtocol!
    
    init(_ dateProvider: DateProviderProtocol) {
        self.dateProvider = dateProvider
    }
    
    func removeOldReminders(in reminderList: ReminderList) {
        reminderList.enumerated().filter { _, reminder in
            isReminderOld(reminder)
        }.reversed().forEach { index, _ in
            reminderList.deleteReminder(index: index)
        }
    }
    
    private func isReminderOld(_ reminder: Reminder) -> Bool {
        let deadline = Calendar.current.date(byAdding: .hour, value: -12, to: dateProvider.now)!
        return reminder.date < deadline
    }
    
}
