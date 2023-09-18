//
//  MockReminderList.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/18.
//

import Foundation
@testable import quick_reminder

import Foundation

class MockReminderList: ReminderListProtocol {
    
    var reminders: [Reminder] = []
    var getReminderReturn: Reminder = Reminder(id: "", title: "", date: Date())
    private(set) var deletedIndices = [Int]()
    
    var notificationCenter: NotificationCenter = NotificationCenter()
    var count: Int = 0
    var isEmpty: Bool = true
    
    func fetchReminders() {
    }
    
    func getReminder(index: Int) -> Reminder {
        return getReminderReturn
    }
    
    func getIndex(reminder: Reminder) throws -> Int {
        return 0
    }
    
    func addReminder(reminder: Reminder) throws {
        count += 1
    }
    
    func deleteReminder(index: Int) {
        deletedIndices.append(index)
        count -= 1
    }
    
    func deleteReminder(reminder: Reminder) throws {
        count -= 1
    }
    
    func updateReminder(reminder: Reminder) throws {
    }
    
    func enumerated() -> EnumeratedSequence<[Reminder]> {
        return reminders.enumerated()
    }
}
