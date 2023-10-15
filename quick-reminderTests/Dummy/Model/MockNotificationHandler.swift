//
//  MockNotificationHandler.swift
//  quick-reminderTests
//  
//  Created by Seigetsu on 2023/10/15
//  
//

import Foundation
@testable import quick_reminder

class MockNotificationHandler: NotificationHandlerProtocol {
    private(set) var registeredReminder = [Reminder]()
    private(set) var removedReminder = [Reminder]()

    func registerNotification(reminder: Reminder) {
        registeredReminder.append(reminder)
    }
    
    func removeNotification(reminder: Reminder) {
        removedReminder.append(reminder)
    }
}
