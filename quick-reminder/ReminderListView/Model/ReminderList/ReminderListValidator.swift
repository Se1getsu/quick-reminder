//
//  ReminderListValidator.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/14.
//

import Foundation

/// ReminderListの操作における妥当性確認のためのメソッド。
protocol ReminderListValidatorProtocol {
    func validateNotContained(reminders: [Reminder], newReminder: Reminder) throws
    func validateContains(reminders: [Reminder], newReminder: Reminder) throws
}

/// ReminderListの操作における妥当性確認を行う。
struct ReminderListValidator: ReminderListValidatorProtocol {
    
    enum ValidationError: Error {
        case alreadyContained(id: String)
        case notFound(id: String)
    }
    
    /// 与えられたReminder配列内に与えられたReminderとIDが一致するものを含まないことを確認する。
    func validateNotContained(reminders: [Reminder], newReminder reminder: Reminder) throws {
        if reminders.contains(where: { $0.id == reminder.id }) {
            throw ValidationError.alreadyContained(id: reminder.id)
        }
    }
    
    /// 与えられたReminder配列内に与えられたReminderとIDが一致するものを含むことを確認する。
    func validateContains(reminders: [Reminder], newReminder reminder: Reminder) throws {
        if !reminders.contains(where: { $0.id == reminder.id }) {
            throw ValidationError.notFound(id: reminder.id)
        }
    }
    
}
