//
//  ReminderList.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/09.
//

import Foundation

final class ReminderList {
    
    private let reminderRepository = ReminderRepository.shared
    private var reminders: [Reminder] = []
    
    init() {
        fetchReminders()
    }
    
    func fetchReminders() {
        reminders = Array(reminderRepository.getAllReminders())
    }
    
    func getLength() -> Int{
        return reminders.count
    }
    
    func getReminder(index: Int) -> Reminder {
        return reminders[index]
    }
    
}
