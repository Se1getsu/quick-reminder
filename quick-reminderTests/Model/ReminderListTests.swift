//
//  ReminderListTests.swift
//  quick-reminderTests
//
//  Created by Seigetsu on 2023/09/17.
//

import XCTest
@testable import quick_reminder

class ReminderListTests: XCTestCase, ReminderListDelegate {
    var reminderList: ReminderList!
    
    var repository: MockReminderRepository!
    var sorter: MockReminderSorter!
    var validator: MockReminderListValidator!
    
    enum DelegateNotification {
        case didAddReminder
        case didDeleteReminder
        case didMoveReminder
        case didUpdateReminder
    }
    var delegateNotification = [DelegateNotification]()
    
    func didAddReminder(_ reminder: quick_reminder.Reminder) {
        delegateNotification.append(.didAddReminder)
    }
    func didDeleteReminder(_ reminder: quick_reminder.Reminder, index: Int) {
        delegateNotification.append(.didDeleteReminder)
    }
    func didMoveReminder(at fromIndex: Int, to toIndex: Int) {
        delegateNotification.append(.didMoveReminder)
    }
    func didUpdateReminder(_ updatedReminder: quick_reminder.Reminder, newIndex index: Int) {
        delegateNotification.append(.didUpdateReminder)
    }
    
    enum MyError: Error {
        case SampleError
    }
    
    override func setUp() {
        super.setUp()
        repository = MockReminderRepository()
        sorter = MockReminderSorter()
        validator = MockReminderListValidator()
        reminderList = ReminderList(repository: repository, sorter: sorter, validator: validator)
        reminderList.delegate = self
    }
    
    override func tearDown() {
        reminderList = nil
        repository = nil
        sorter = nil
        reminderList = nil
        delegateNotification = []
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
        validator.validateNotContainsError = nil
        sorter.sortedReminders = [newReminder]
        
        // リマインダーを追加
        XCTAssertNoThrow(try reminderList.addReminder(reminder: newReminder))
        
        XCTAssertTrue(validator.validateNotContainsCalled)
        XCTAssertEqual(repository.addedReminders.count, 1)
        XCTAssertEqual(sorter.givenReminders?.count, 1)
        XCTAssertEqual(reminderList.count, 1)
        
        // 通知を確認
        XCTAssertEqual(delegateNotification.count, 1)
        XCTAssertEqual(delegateNotification[0], .didAddReminder)
    }
    
    func testAddReminder_失敗() {
        let newReminder = Reminder(id: "123", title: "Test Reminder", date: Date())
        let throwError = MyError.SampleError
        validator.validateNotContainsError = throwError
        sorter.sortedReminders = [newReminder]
        
        // リマインダーの追加に失敗
        XCTAssertThrowsError(try reminderList.addReminder(reminder: newReminder)) { error in
            XCTAssertEqual(error as? ReminderListTests.MyError, throwError)
        }
        XCTAssertEqual(delegateNotification.count, 0)
    }
    
    func testDeleteReminder() {
        // 適当なリマインダーを追加
        let newReminder = Reminder(id: "123", title: "Test Reminder", date: Date())
        validator.validateNotContainsError = nil
        sorter.sortedReminders = [newReminder]
        XCTAssertNoThrow(try reminderList.addReminder(reminder: newReminder))
        
        sorter.sortedReminders = []
        delegateNotification = []
        
        // リマインダーを削除
        reminderList.deleteReminders(indices: [0])
        
        XCTAssertEqual(repository.deletedReminders.count, 1)
        XCTAssertEqual(sorter.givenReminders?.count, 0)
        XCTAssertTrue(reminderList.isEmpty)
        
        // 通知を確認
        XCTAssertEqual(delegateNotification.count, 1)
        XCTAssertEqual(delegateNotification[0], .didDeleteReminder)
    }
    
    func testUpdateReminder_成功() {
        // 適当なリマインダーを追加
        let newReminder = Reminder(id: "123", title: "Test Reminder", date: Date())
        validator.validateNotContainsError = nil
        sorter.sortedReminders = [newReminder]
        XCTAssertNoThrow(try reminderList.addReminder(reminder: newReminder))
        
        let updatedReminder = Reminder(id: "123", title: "Updated Reminder", date: Date())
        validator.validateContainsError = nil
        sorter.sortedReminders = [updatedReminder]
        delegateNotification = []
        
        // リマインダーを更新
        XCTAssertNoThrow(try reminderList.updateReminder(reminder: updatedReminder))
        
        XCTAssertTrue(validator.validateContainsCalled)
        XCTAssertEqual(repository.updatedReminders.count, 1)
        XCTAssertEqual(sorter.givenReminders?.count, 1)
        XCTAssertEqual(reminderList.reminders[0].title, updatedReminder.title)
        
        // 通知を確認
        XCTAssertEqual(delegateNotification.count, 2)
        // NOTE: インデックスが合わなくなるので .didMoveReminder が先に通知されるべき。
        XCTAssertEqual(delegateNotification[0], .didMoveReminder)
        XCTAssertEqual(delegateNotification[1], .didUpdateReminder)
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
