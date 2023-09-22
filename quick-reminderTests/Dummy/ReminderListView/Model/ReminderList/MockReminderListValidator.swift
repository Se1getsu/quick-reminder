//
//  MockReminderListValidator.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/17.
//

import Foundation
@testable import quick_reminder

class MockReminderListValidator: ReminderListValidatorProtocol {
    private(set) var validateNotContainsCalled = false
    private(set) var validateContainsCalled = false
    var validateNotContainsError: Error?
    var validateContainsError: Error?
    
    func validateNotContains(_ reminder: Reminder, in reminders: [Reminder]) throws {
        validateNotContainsCalled = true
        if let error = validateNotContainsError {
            throw error
        }
    }
    
    func validateContains(_ reminder: Reminder, in reminders: [Reminder]) throws {
        validateContainsCalled = true
        if let error = validateContainsError {
            throw error
        }
    }
}
