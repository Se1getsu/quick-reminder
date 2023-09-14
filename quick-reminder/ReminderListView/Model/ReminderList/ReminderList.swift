//
//  ReminderList.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/09.
//

import Foundation

final class ReminderList {
    
    let notificationCenter = NotificationCenter()
    
    private let repository: ReminderRepositoryDelegate!
    private let sorter: ReminderSorterProtocol!
    private let validator: ReminderListValidatorProtocol!
    
    private var reminders: [Reminder] = [] {
        didSet {
            reminders = sorter.sorted(reminders)
        }
    }
    var count: Int { reminders.count }
    
    init(_ repository: ReminderRepositoryDelegate,
         _ sorter: ReminderSorterProtocol,
         _ validator: ReminderListValidatorProtocol) {
        self.repository = repository
        self.validator = validator
        self.sorter = sorter
        fetchReminders()
    }
    
    func fetchReminders() {
        reminders = repository.getAllReminders()
    }
    
    func getReminder(index: Int) -> Reminder {
        return reminders[index]
    }
    
    func getIndex(reminder: Reminder) throws -> Int {
        try validator.validateContains(reminders: reminders, newReminder: reminder)
        return reminders.firstIndex { $0.id == reminder.id }!
    }
    
    func addReminder(reminder: Reminder) throws {
        try validator.validateNotContained(reminders: reminders, newReminder: reminder)
        repository.addReminder(reminder)
        reminders.append(reminder)
        notificationCenter.post(name: .init("didAddReminder"), object: nil, userInfo: ["reminder": reminder])
    }
    
    func deleteReminder(index: Int) {
        let reminder = reminders.remove(at: index)
        repository.deleteReminder(reminder)
        notificationCenter.post(name: .init("didDeleteReminder"), object: nil, userInfo: ["reminder": reminder])
    }
    
    func deleteReminder(reminder: Reminder) throws {
        let index = try getIndex(reminder: reminder)
        deleteReminder(index: index)
    }
    
    
    func updateReminder(reminder: Reminder) throws {
        let index = try getIndex(reminder: reminder)
        repository.updateReminder(reminder)
        reminders[index] = reminder
        notificationCenter.post(name: .init("didUpdateReminder"), object: nil, userInfo: ["reminder": reminder])
    }
    
    func enumerated() -> EnumeratedSequence<[Reminder]> {
        return reminders.enumerated()
    }
    
}
