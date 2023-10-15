//
//  MockReminderEditDelegate.swift
//  quick-reminderTests
//  
//  Created by Seigetsu on 2023/10/12
//  
//

import Foundation
@testable import quick_reminder

class MockReminderEditDelegate: ReminderEditDelegate {
    private(set) var createdReminder: Reminder?
    private(set) var editedReminder: Reminder?
    
    func createReminder(_ reminder: Reminder) {
        createdReminder = reminder
    }
    
    func didEditReminder(editedReminder: Reminder) {
        self.editedReminder = editedReminder
    }
}
