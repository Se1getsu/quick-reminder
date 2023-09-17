//
//  MockReminderSorter.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/17.
//

import Foundation
@testable import quick_reminder

class MockReminderSorter: ReminderSorterProtocol {
    
    private(set) var givenReminders: [Reminder]?
    var sortedReminders: [Reminder] = []
    
    func sorted(_ reminders: [Reminder]) -> [Reminder] {
        givenReminders = reminders
        return sortedReminders
    }
    
}
