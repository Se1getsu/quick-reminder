//
//  ReminderList.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/09.
//

import Foundation

final class ReminderList {
    
    let notificationCenter = NotificationCenter()
    
    private let reminderRepository = ReminderRepository.shared
    private var reminders: [Reminder] = [] {
        didSet {
            for reminder in reminders {
                reminder.notificationCenter.addObserver(
                    forName: .init("didChange"),
                    object: nil,
                    queue: nil,
                    using: { [unowned self] _ in
                        self.notificationCenter.post(name: .init("reminderDidChange"), object: nil)
                    }
                )
            }
        }
    }
    
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
    
    func addReminder(title: String, date: Date) {
        let reminder = Reminder()
        reminder.title = title
        reminder.date = date
        reminderRepository.addReminder(reminder)
        reminders.append(reminder)
        notificationCenter.post(name: .init("newReminder"), object: nil)
    }
    
    func deleteReminder(index: Int) {
        let reminder = reminders.remove(at: index)
        reminderRepository.deleteReminder(reminder)
        notificationCenter.post(name: .init("deleteReminder"), object: nil)
    }
    
}
