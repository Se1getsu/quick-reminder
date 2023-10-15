//
//  ReminderEditPresenterTests.swift
//  quick-reminderTests
//  
//  Created by Seigetsu on 2023/10/12
//  
//

import XCTest
@testable import quick_reminder

final class ReminderEditPresenterTests: XCTestCase {
    var notificationDateCalculator: MockNotificationDateCalculator!
    var view: MockReminderEditOutput!
    var delegate: MockReminderEditDelegate!
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    override func setUp() {
        notificationDateCalculator = MockNotificationDateCalculator()
        view = MockReminderEditOutput()
        delegate = MockReminderEditDelegate()
    }
    
    func testViewDidLoad_新規作成() {
        let defaultReminder = Reminder(
            title: "Sample Hogehoge",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .create(defaultReminder: defaultReminder)
        )
        
        presenter.viewDidLoad()
        XCTAssertEqual(view.title, "新規作成")
        XCTAssertEqual(view.reminderTitle, defaultReminder.title)
        XCTAssertEqual(view.reminderDate, defaultReminder.date)
    }
    
    func testViewDidLoad_編集() {
        let defaultReminder = Reminder(
            title: "Sample Hogehoge",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .update(currentReminder: defaultReminder)
        )
        
        presenter.viewDidLoad()
        XCTAssertEqual(view.title, "編集")
        XCTAssertEqual(view.reminderTitle, defaultReminder.title)
        XCTAssertEqual(view.reminderDate, defaultReminder.date)
    }
    
    func test_デフォルトタイトルはプレースホルダーとして表示される() {
        let defaultTitle = Reminder.defaultTitle
        let defaultReminder = Reminder(
            title: defaultTitle,
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .create(defaultReminder: defaultReminder)
        )
        XCTAssertEqual(presenter.reminderTitlePlaceHodler, defaultTitle)
        
        presenter.viewDidLoad()
        XCTAssertEqual(view.reminderTitle, "")
    }
    
    func test_キャンセル_変更なし() {
        let defaultReminder = Reminder(
            title: "テスト",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .update(currentReminder: defaultReminder)
        )
        
        presenter.cancelButtonTapped(
            title: "テスト",
            date: formatter.date(from: "1000/01/01 14:30:00")!
        )
        XCTAssertTrue(view.dismissViewCalled)
    }
    
    func test_キャンセル_変更あり_編集() {
        let defaultReminder = Reminder(
            title: "テスト",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .update(currentReminder: defaultReminder)
        )
        
        presenter.cancelButtonTapped(
            title: "テスト",
            date: formatter.date(from: "1000/01/01 14:35:00")!
        )
        XCTAssertFalse(view.dismissViewCalled)
        XCTAssertEqual(view.cancelAlertMessage, "この変更を破棄しますか？")
        
        presenter.discardButtonOnCancelAlertTapped()
        XCTAssertTrue(view.dismissViewCalled)
    }
    
    func test_キャンセル_変更あり_新規作成() {
        let defaultReminder = Reminder(
            title: "テスト",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .create(defaultReminder: defaultReminder)
        )
        
        presenter.cancelButtonTapped(
            title: "テスト",
            date: formatter.date(from: "1000/01/01 14:35:00")!
        )
        XCTAssertFalse(view.dismissViewCalled)
        XCTAssertEqual(view.cancelAlertMessage, "この新規リマインダーを破棄しますか？")
        
        presenter.discardButtonOnCancelAlertTapped()
        XCTAssertTrue(view.dismissViewCalled)
    }
    
    func test_保存_編集() {
        let defaultReminder = Reminder(
            title: "テスト",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .update(currentReminder: defaultReminder)
        )
        presenter.delegate = delegate
        
        notificationDateCalculator.calculateReturn = formatter.date(from: "2023/10/11 08:22:00")!
        presenter.saveButtonTapped(
            title: "Hello",
            date: formatter.date(from: "1000/01/01 08:22:00")!
        )
        XCTAssertEqual(notificationDateCalculator.targetDate!, formatter.date(from: "1000/01/01 08:22:00")!)
        let resultReminder = delegate.editedReminder!
        XCTAssertEqual(resultReminder.title, "Hello")
        XCTAssertEqual(resultReminder.date, formatter.date(from: "2023/10/11 08:22:00")!)
    }
    
    func test_保存_新規作成() {
        let defaultReminder = Reminder(
            title: "sample",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .update(currentReminder: defaultReminder)
        )
        presenter.delegate = delegate
        
        notificationDateCalculator.calculateReturn = formatter.date(from: "2023/10/10 17:50:00")!
        presenter.saveButtonTapped(
            title: "",
            date: formatter.date(from: "1000/01/01 17:50:00")!
        )
        XCTAssertEqual(notificationDateCalculator.targetDate!, formatter.date(from: "1000/01/01 17:50:00")!)
        let resultReminder = delegate.editedReminder!
        XCTAssertEqual(resultReminder.title, Reminder.defaultTitle)
        XCTAssertEqual(resultReminder.date, formatter.date(from: "2023/10/10 17:50:00")!)
    }
}
