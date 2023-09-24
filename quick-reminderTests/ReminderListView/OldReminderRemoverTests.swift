//
//  OldReminderRemoverTests.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/18.
//

import XCTest
@testable import quick_reminder

final class OldReminderRemoverTests: XCTestCase {
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    func testRemoveOldReminders_12時間経過直前() {
        let nowDate   = formatter.date(from: "2023/10/10 14:30:00")!
        let before12h = formatter.date(from: "2023/10/10 02:31:00")!
        
        let dateProvider = StubDateProvider(now: nowDate)
        var reminderList: ReminderListProtocol = MockReminderList()
        (reminderList as! MockReminderList).reminders = [
            Reminder(date: before12h)
        ]
        (reminderList as! MockReminderList).count = 1

        let remover = OldReminderRemover(dateProvider: dateProvider)
        remover.removeOldReminders(in: &reminderList)

        XCTAssertEqual((reminderList as! MockReminderList).reminders.count, 1)
        XCTAssertTrue((reminderList as! MockReminderList).deletedIndices.isEmpty)
    }
    
    func testRemoveOldReminders_12時間経過() {
        let nowDate   = formatter.date(from: "2023/10/10 14:30:00")!
        let before12h = formatter.date(from: "2023/10/10 02:30:00")!
        
        let dateProvider = StubDateProvider(now: nowDate)
        var reminderList: ReminderListProtocol = MockReminderList()
        (reminderList as! MockReminderList).reminders = [
            Reminder(date: before12h)
        ]
        (reminderList as! MockReminderList).count = 1

        let remover = OldReminderRemover(dateProvider: dateProvider)
        remover.removeOldReminders(in: &reminderList)

        XCTAssertEqual((reminderList as! MockReminderList).count, 0)
        XCTAssertEqual((reminderList as! MockReminderList).deletedIndices, [0])
    }

}
