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
    var sampleReminder: Reminder!
    var delegate: MockReminderEditDelegate!
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    override func setUp() {
        notificationDateCalculator = MockNotificationDateCalculator()
        view = MockReminderEditOutput()
        sampleReminder = Reminder(
            title: "Sample Hogehoge",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        delegate = MockReminderEditDelegate()
    }
    
    func testViewDidLoad_新規作成() {
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .create(defaultReminder: sampleReminder)
        )
        presenter.viewDidLoad()
        
        XCTAssertEqual(view.title, "新規作成")
        XCTAssertEqual(view.reminderTitle, sampleReminder.title)
        XCTAssertEqual(view.reminderDate, sampleReminder.date)
    }
    
    func testViewDidLoad_編集() {
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .update(currentReminder: sampleReminder)
        )
        presenter.viewDidLoad()
        
        XCTAssertEqual(view.title, "編集")
        XCTAssertEqual(view.reminderTitle, sampleReminder.title)
        XCTAssertEqual(view.reminderDate, sampleReminder.date)
    }
    
    func test_デフォルトタイトルは空文字列となって表示される() {
        let anotherReminder = Reminder(
            title: "新規リマインダー",
            date: formatter.date(from: "2023/10/10 14:30:00")!
        )
        let presenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: notificationDateCalculator
            ),
            view: view,
            editMode: .create(defaultReminder: anotherReminder)
        )
        presenter.viewDidLoad()
        
        XCTAssertEqual(view.reminderTitle, "")
    }
}
