//
//  MockReminderSorter.swift
//  quick-reminderTests
//
//  Created by Seigetsu on 2023/09/17.
//

import Foundation
@testable import quick_reminder

class MockReminderSorter: ReminderSorterProtocol {
    
    private(set) var givenReminders: [Reminder]?
    var sortedReminders: [Reminder] = []
    
    func sorted(reminders: [Reminder]) -> [Reminder] {
        givenReminders = reminders
        return sortedReminders
    }
    
}
