//
//  MockReminderList.swift
//  quick-reminderTests
//
//  Created by Seigetsu on 2023/09/18.
//

import Foundation
@testable import quick_reminder

class MockReminderList: ReminderListProtocol {
    
    var reminders: [Reminder] = []
    var delegate: ReminderListDelegate?
    
    var getReminderReturn: Reminder = Reminder(id: "", title: "", date: Date())
    private(set) var getReminderIndices = [Int]()
    private(set) var deletedIndices = [Int]()
    private(set) var updatedReminders = [Reminder]()
    
    var count: Int = 0
    var isEmpty: Bool = true
    
    func fetchReminders() {
    }
    
    func getReminder(index: Int) -> Reminder {
        getReminderIndices.append(index)
        return getReminderReturn
    }
    
    func getIndex(reminder: Reminder) throws -> Int {
        return 0
    }
    
    func addReminder(reminder: Reminder) throws {
        reminders.append(reminder)
        count += 1
    }
    
    func deleteReminders(indices: [Int]) {
        deletedIndices.append(contentsOf: indices)
        count -= indices.count
    }
    
    func deleteReminder(index: Int) {
        deletedIndices.append(index)
        count -= 1
    }
    
    func deleteReminder(reminder: Reminder) throws {
        count -= 1
    }
    
    func updateReminder(reminder: Reminder) throws {
        updatedReminders.append(reminder)
    }
    
    func enumerated() -> EnumeratedSequence<[Reminder]> {
        return reminders.enumerated()
    }
}
