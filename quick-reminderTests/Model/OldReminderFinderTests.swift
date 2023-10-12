//
//  OldReminderFinderTests.swift
//  quick-reminderTests
//
//  Created by Seigetsu on 2023/09/18.
//

import XCTest
@testable import quick_reminder

final class OldReminderFinderTests: XCTestCase {
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    func testRemoveOldReminders_12時間経過直前() {
        let nowDate   = formatter.date(from: "2023/10/10 14:30:00")!
        let before12h = formatter.date(from: "2023/10/10 02:31:00")!
        
        let dateProvider = StubDateProvider(now: nowDate)
        let reminderList: ReminderListProtocol = MockReminderList()
        (reminderList as! MockReminderList).reminders = [
            Reminder(date: before12h)
        ]
        (reminderList as! MockReminderList).count = 1

        let remover = OldReminderFinder(dateProvider: dateProvider)
        let result = remover.getOldReminderIndices(in: reminderList)
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testRemoveOldReminders_12時間経過() {
        let nowDate   = formatter.date(from: "2023/10/10 14:30:00")!
        let before12h = formatter.date(from: "2023/10/10 02:30:00")!
        
        let dateProvider = StubDateProvider(now: nowDate)
        let reminderList: ReminderListProtocol = MockReminderList()
        (reminderList as! MockReminderList).reminders = [
            Reminder(date: before12h)
        ]
        (reminderList as! MockReminderList).count = 1

        let remover = OldReminderFinder(dateProvider: dateProvider)
        let result = remover.getOldReminderIndices(in: reminderList)
        
        XCTAssertEqual(result, [0])
    }

}
