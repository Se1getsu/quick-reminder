//
//  MockReminderEditOutput.swift
//  quick-reminderTests
//  
//  Created by Seigetsu on 2023/10/12
//  
//

import Foundation
@testable import quick_reminder

class MockReminderEditOutput: ReminderEditPresenterOutput {
    private(set) var title: String?
    private(set) var dismissViewCalled = false
    private(set) var reminderTitle: String?
    private(set) var reminderDate: Date?
    private(set) var cancelAlertMessage: String?
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func dismissView() {
        dismissViewCalled = true
    }
    
    func setUpReminderOnView(title: String, date: Date) {
        reminderTitle = title
        reminderDate = date
    }
    
    func showCancelAlert(message: String) {
        cancelAlertMessage = message
    }
}
