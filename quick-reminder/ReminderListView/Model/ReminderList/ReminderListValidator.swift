//
//  ReminderListValidator.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/14.
//

import Foundation

protocol ReminderListValidatorProtocol {
    func validateNotContained(reminders: [Reminder], newReminder: Reminder) throws
    func validateContains(reminders: [Reminder], newReminder: Reminder) throws
}

struct ReminderListValidator: ReminderListValidatorProtocol {
    
    enum ValidationError: Error {
        case alreadyContained(id: String)
        case notFound(id: String)
    }
    
    func validateNotContained(reminders: [Reminder], newReminder reminder: Reminder) throws {
        if reminders.contains(where: { $0.id == reminder.id }) {
            throw ValidationError.alreadyContained(id: reminder.id)
        }
    }
    
    func validateContains(reminders: [Reminder], newReminder reminder: Reminder) throws {
        if !reminders.contains(where: { $0.id == reminder.id }) {
            throw ValidationError.notFound(id: reminder.id)
        }
    }
    
}
