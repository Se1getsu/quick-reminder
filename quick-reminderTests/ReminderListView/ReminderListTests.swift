//
//  ReminderListTests.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/17.
//

import XCTest
@testable import quick_reminder

class ReminderListTests: XCTestCase {
    
    var reminderList: ReminderList!
    
    var repository: MockReminderRepository!
    var sorter: MockReminderSorter!
    var validator: MockReminderListValidator!
    
    var notification: Notification?
    
    enum MyError: Error {
        case SampleError
    }
    
    override func setUp() {
        super.setUp()
        repository = MockReminderRepository()
        sorter = MockReminderSorter()
        validator = MockReminderListValidator()
        reminderList = ReminderList(repository, sorter, validator)
        
        reminderList.notificationCenter.addObserver(
            forName: .didAddReminder,
            object: nil,
            queue: nil,
            using: { [unowned self] notification in
                self.notification = notification
            }
        )
        reminderList.notificationCenter.addObserver(
            forName: .didDeleteReminder,
            object: nil,
            queue: nil,
            using: { [unowned self] notification in
                self.notification = notification
            }
        )
        reminderList.notificationCenter.addObserver(
            forName: .didUpdateReminder,
            object: nil,
            queue: nil,
            using: { [unowned self] notification in
                self.notification = notification
            }
        )
    }
    
    override func tearDown() {
        reminderList = nil
        repository = nil
        sorter = nil
        reminderList = nil
        notification = nil
        super.tearDown()
    }
    
    func testFetchReminders() {
        let reminders = Array.init(repeating: Reminder(date: Date()), count: 3)
        repository.allReminders = reminders
        sorter.sortedReminders = reminders
        
        // リマインダーをフェッチ
        reminderList.fetchReminders()
        
        XCTAssertEqual(sorter.givenReminders?.count, 3)
        XCTAssertEqual(reminderList.count, 3)
    }
    
    func testAddReminder_成功() {
        let newReminder = Reminder(id: "123", title: "Test Reminder", date: Date())
        validator.validateNotContainedError = nil
        sorter.sortedReminders = [newReminder]
        
        // リマインダーを追加
        XCTAssertNoThrow(try reminderList.addReminder(reminder: newReminder))
        
        XCTAssertTrue(validator.validateNotContainedCalled)
        XCTAssertEqual(repository.addedReminders.count, 1)
        XCTAssertEqual(sorter.givenReminders?.count, 1)
        XCTAssertEqual(reminderList.count, 1)
        
        // 通知を確認
        XCTAssertNotNil(notification)
        XCTAssertEqual(notification?.name, .didAddReminder)
        XCTAssertNotNil(notification?.userInfo?["reminder"] as? Reminder)
    }
    
    func testAddReminder_失敗() {
        let newReminder = Reminder(id: "123", title: "Test Reminder", date: Date())
        let throwError = MyError.SampleError
        validator.validateNotContainedError = throwError
        sorter.sortedReminders = [newReminder]
        
        // リマインダーの追加に失敗
        XCTAssertThrowsError(try reminderList.addReminder(reminder: newReminder)) { error in
            XCTAssertEqual(error as? ReminderListTests.MyError, throwError)
        }
        XCTAssertNil(notification)
    }
    
    func testDeleteReminder() {
        // 適当なリマインダーを追加
        let newReminder = Reminder(id: "123", title: "Test Reminder", date: Date())
        validator.validateNotContainedError = nil
        sorter.sortedReminders = [newReminder]
        XCTAssertNoThrow(try reminderList.addReminder(reminder: newReminder))
        
        sorter.sortedReminders = []
        
        // リマインダーを削除
        reminderList.deleteReminder(index: 0)
        
        XCTAssertEqual(repository.deletedReminders.count, 1)
        XCTAssertEqual(sorter.givenReminders?.count, 0)
        XCTAssertTrue(reminderList.isEmpty)
        
        // 通知を確認
        XCTAssertNotNil(notification)
        XCTAssertEqual(notification?.name, .didDeleteReminder)
        XCTAssertNotNil(notification?.userInfo?["reminder"] as? Reminder)
    }
    
    func testUpdateReminder_成功() {
        // 適当なリマインダーを追加
        let newReminder = Reminder(id: "123", title: "Test Reminder", date: Date())
        validator.validateNotContainedError = nil
        sorter.sortedReminders = [newReminder]
        XCTAssertNoThrow(try reminderList.addReminder(reminder: newReminder))
        
        let updatedReminder = Reminder(id: "123", title: "Updated Reminder", date: Date())
        validator.validateContainsError = nil
        sorter.sortedReminders = [updatedReminder]
        
        // リマインダーを更新
        XCTAssertNoThrow(try reminderList.updateReminder(reminder: updatedReminder))
        
        XCTAssertTrue(validator.validateContainsCalled)
        XCTAssertEqual(repository.updatedReminders.count, 1)
        XCTAssertEqual(sorter.givenReminders?.count, 1)
        XCTAssertEqual(reminderList.getReminder(index: 0).title, updatedReminder.title)
        
        // 通知を確認
        XCTAssertNotNil(notification)
        XCTAssertEqual(notification?.name, .didUpdateReminder)
        XCTAssertNotNil(notification?.userInfo?["reminder"] as? Reminder)
    }
    
    func testUpdateReminder_失敗() {
        let updatedReminder = Reminder(id: "123", title: "Updated Reminder", date: Date())
        let throwError = MyError.SampleError
        validator.validateContainsError = throwError
        sorter.sortedReminders = [updatedReminder]
        
        // リマインダーの更新に失敗
        XCTAssertThrowsError(try reminderList.updateReminder(reminder: updatedReminder)) { error in
            XCTAssertEqual(error as? ReminderListTests.MyError, throwError)
        }
    }
    
}
