//
//  MockNotificationDateCalculator.swift
//  quick-reminderTests
//  
//  Created by Seigetsu on 2023/10/14
//  
//

import Foundation
@testable import quick_reminder

class MockNotificationDateCalculator: NotificationDateCalculatorProtocol {
    var calculateReturn: Date!
    private(set) var targetDate: Date?
    
    func calculate(from date: Date) -> Date {
        targetDate = date
        return calculateReturn
    }
}
