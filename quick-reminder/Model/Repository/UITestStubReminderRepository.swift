//
//  UITestStubReminderRepository.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/19.
//

import Foundation

/// ReminderRepositoryのモック。UITest用で使用する。
///
/// アプリ起動時に `-useUITestMockRepository` オプションを付加することで使用できる。
class UITestStubReminderRepository: ReminderRepositoryProtocol {
    private var reminders = [Reminder]()

    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }

    func updateReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
        reminders.append(reminder)
    }

    func deleteReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
    }

    func getAllReminders() -> [Reminder] {
        reminders
    }

    func getReminder(withID id: String) -> Reminder? {
        reminders.first { $0.id == id }
    }
}
