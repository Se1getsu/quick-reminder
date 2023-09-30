//
//  ReminderListValidator.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/14.
//

import Foundation

/// ReminderListの操作における妥当性確認のためのメソッド。
protocol ReminderListValidatorProtocol {
    /// 与えられたReminder配列内に与えられたReminderとIDが一致するものを含まないことを確認する。
    ///
    /// 一致するReminderが見つかった場合、エラーを投げる。
    func validateNotContains(_: Reminder, in: [Reminder]) throws
    
    /// 与えられたReminder配列内に与えられたReminderとIDが一致するものを含むことを確認する。
    ///
    /// 一致するReminderが見つからなかった場合、エラーを投げる。
    func validateContains(_: Reminder, in: [Reminder]) throws
}

/// ReminderListの操作における妥当性確認を行う。
struct ReminderListValidator: ReminderListValidatorProtocol {
    enum ValidationError: Error {
        case alreadyContained(id: String)
        case notFound(id: String)
    }
    
    func validateNotContains(_ reminder: Reminder, in reminders: [Reminder]) throws {
        if reminders.contains(where: { $0.id == reminder.id }) {
            throw ValidationError.alreadyContained(id: reminder.id)
        }
    }
    
    func validateContains(_ reminder: Reminder, in reminders: [Reminder]) throws {
        if !reminders.contains(where: { $0.id == reminder.id }) {
            throw ValidationError.notFound(id: reminder.id)
        }
    }
}
