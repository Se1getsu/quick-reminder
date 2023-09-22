//
//  MockReminderRepository.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/17.
//

import Foundation
@testable import quick_reminder

class MockReminderRepository: ReminderRepositoryProtocol {
    private(set) var addedReminders: [Reminder] = []
    private(set) var updatedReminders: [Reminder] = []
    private(set) var deletedReminders: [Reminder] = []
    var allReminders: [Reminder] = []
    var reminderWithID: Reminder?

    func addReminder(_ reminder: Reminder) {
        addedReminders.append(reminder)
    }

    func updateReminder(_ reminder: Reminder) {
        updatedReminders.append(reminder)
    }

    func deleteReminder(_ reminder: Reminder) {
        deletedReminders.append(reminder)
    }

    func getAllReminders() -> [Reminder] {
        return allReminders
    }

    func getReminder(withID id: String) -> Reminder? {
        return reminderWithID
    }
}
