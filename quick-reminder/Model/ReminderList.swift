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
    private var reminders: [Reminder] = []
    
    init() {
        fetchReminders()
        
        reminderRepository.notificationCenter.addObserver(
            forName: .init("update"),
            object: nil,
            queue: nil,
            using: { [unowned self] _ in
                self.notificationCenter.post(name: .init("updateReminder"), object: nil)
            })
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
    
    func addReminder(title: String, date: Date) -> Int {
        let reminder = Reminder()
        reminder.title = title
        reminder.date = date
        reminderRepository.addReminder(reminder)
        reminders.append(reminder)
        notificationCenter.post(name: .init("newReminder"), object: nil)
        return reminders.firstIndex(of: reminder)!
    }
    
    func deleteReminder(index: Int) {
        let reminder = reminders.remove(at: index)
        reminderRepository.deleteReminder(reminder)
        notificationCenter.post(name: .init("deleteReminder"), object: nil)
    }
    
}
