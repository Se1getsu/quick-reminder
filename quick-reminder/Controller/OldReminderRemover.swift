//
//  OldReminderRemover.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/13.
//

import Foundation

protocol OldReminderRemoverProtocol {
    func removeOldReminders(_ reminders: ReminderList)
}

final class OldReminderRemover: OldReminderRemoverProtocol {
    
    let dateProvider: DateProviderProtocol!
    
    init(_ dateProvider: DateProviderProtocol) {
        self.dateProvider = dateProvider
    }
    
    func removeOldReminders(_ reminderList: ReminderList) {
        let deadline = Calendar.current.date(byAdding: .hour, value: -24, to: dateProvider.now)!
        reminderList.enumerated().reversed().forEach({ index, reminder in
            if reminder.date < deadline {
                reminderList.deleteReminder(index: index)
            }
        })
    }
    
}
