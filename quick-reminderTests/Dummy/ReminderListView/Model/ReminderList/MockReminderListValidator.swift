//
//  MockReminderListValidator.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/17.
//

import Foundation
@testable import quick_reminder

class MockReminderListValidator: ReminderListValidatorProtocol {
    private(set) var validateNotContainedCalled = false
    private(set) var validateContainsCalled = false
    var validateNotContainedError: Error?
    var validateContainsError: Error?
    
    func validateNotContained(reminders: [Reminder], newReminder reminder: Reminder) throws {
        validateNotContainedCalled = true
        if let error = validateNotContainedError {
            throw error
        }
    }
    
    func validateContains(reminders: [Reminder], newReminder reminder: Reminder) throws {
        validateContainsCalled = true
        if let error = validateContainsError {
            throw error
        }
    }
}
