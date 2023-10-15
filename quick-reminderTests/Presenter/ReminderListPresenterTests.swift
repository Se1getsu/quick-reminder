//
//  ReminderListPresenterTests.swift
//  quick-reminderTests
//  
//  Created by Seigetsu on 2023/10/12
//  
//

import XCTest
@testable import quick_reminder

final class ReminderListPresenterTests: XCTestCase {
    var reminderList: MockReminderList!
    var notificationHandler: MockNotificationHandler!
    var notificationDateCalculator: MockNotificationDateCalculator!
    var oldReminderFinder: MockOldReminderFinder!
    var view: MockReminderListOutput!
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    override func setUp() {
        reminderList = MockReminderList()
        notificationHandler = MockNotificationHandler()
        notificationDateCalculator = MockNotificationDateCalculator()
        oldReminderFinder = MockOldReminderFinder()
        view = MockReminderListOutput()
    }
    
    func makeReminderListPresenter(reminders: [Reminder], oldReminderToRemoveIndices: [Int], nowDate: Date) -> ReminderListPresenter {
        reminderList.reminders = reminders
        oldReminderFinder.getOldReminderIndicesReturn = oldReminderToRemoveIndices
        let presenter = ReminderListPresenter(
            dependency: .init(
                reminderList: reminderList,
                notificationHandler: notificationHandler,
                notificationDateCalculator: notificationDateCalculator,
                dateProvider: StubDateProvider(now: nowDate),
                oldReminderFinder: oldReminderFinder
            ),
            view: view
        )
        presenter.viewDidLoad()
        return presenter
    }
    
    func test_リマインダーの読み込みと表示スタイル計算() {
        let presenter = makeReminderListPresenter(
            reminders: [
                Reminder(title: "Hoge", date: formatter.date(from: "2023/10/10 14:29:00")!),
                Reminder(title: "Piyo", date: formatter.date(from: "2023/10/10 21:00:00")!),
                Reminder(title: "Nyan", date: formatter.date(from: "2023/10/09 18:30:00")!)
            ],
            oldReminderToRemoveIndices: [],
            nowDate: formatter.date(from: "2023/10/10 14:30:00")!
        )
        XCTAssertEqual(presenter.remindersToDisplay.count, 3)
        
        presenter.viewWillAppear()
        XCTAssertEqual(view.setStyles.count, 3)
        XCTAssertEqual(view.setStyles[0], .init(index: 0, style: .notified))
        XCTAssertEqual(view.setStyles[1], .init(index: 1, style: .normal))
        XCTAssertEqual(view.setStyles[2], .init(index: 2, style: .notified))
    }
    
    func test_古いリマインダーの削除() {
        let presenter = makeReminderListPresenter(
            reminders: [
                Reminder(title: "Hoge", date: formatter.date(from: "2023/10/10 14:29:00")!),
                Reminder(title: "Piyo", date: formatter.date(from: "2023/10/10 21:00:00")!),
                Reminder(title: "Nyan", date: formatter.date(from: "2023/10/09 18:30:00")!)
            ],
            oldReminderToRemoveIndices: [0, 2],
            nowDate: formatter.date(from: "2023/10/10 14:30:00")!
        )
        presenter.viewWillAppear()
        XCTAssertEqual(reminderList.deletedIndices, [0, 2])
    }
    
    func test_リマインダー新規作成() {
        let presenter = makeReminderListPresenter(
            reminders: [],
            oldReminderToRemoveIndices: [],
            nowDate: formatter.date(from: "2023/10/10 14:30:00")!
        )
        notificationDateCalculator.calculateReturn = formatter.date(from: "2023/10/11 14:30:00")!
        
        // 追加ボタンをタップ
        presenter.didTapAddButton()
        guard case .create(let reminder) = view.reminderEditVCEditMode else {
            XCTFail(); return
        }
        XCTAssertEqual(notificationDateCalculator.targetDate, formatter.date(from: "2023/10/10 14:30:00")!)
        XCTAssertEqual(reminder.title, Reminder.defaultTitle)
        XCTAssertEqual(reminder.date, formatter.date(from: "2023/10/11 14:30:00")!)
        
        // 編集画面からデリゲートが呼び出された
        presenter.createReminder(Reminder(title: "Foo", date: formatter.date(from: "2023/10/10 20:30:00")!))
        XCTAssertEqual(reminderList.reminders.count, 1)
    }
    
    func test_リマインダー編集() {
        let presenter = makeReminderListPresenter(
            reminders: [
                Reminder(title: "Hoge", date: formatter.date(from: "2023/10/10 14:29:00")!)
            ],
            oldReminderToRemoveIndices: [],
            nowDate: formatter.date(from: "2023/10/10 14:30:00")!
        )
        
        // リマインダーをタップ
        presenter.didTapReminder(index: 0)
        guard case .update(let reminder) = view.reminderEditVCEditMode else {
            XCTFail(); return
        }
        XCTAssertEqual(reminder.title, "Hoge")
        XCTAssertEqual(reminder.date, formatter.date(from: "2023/10/10 14:29:00")!)
        
        // 編集画面からデリゲートが呼び出された
        presenter.didEditReminder(editedReminder: Reminder(title: "Foo", date: formatter.date(from: "2023/10/10 20:30:00")!))
        XCTAssertEqual(reminderList.updatedReminders.count, 1)
    }
    
    func test_リマインダー削除() {
        let presenter = makeReminderListPresenter(
            reminders: [
                Reminder(title: "Hoge", date: formatter.date(from: "2023/10/10 14:29:00")!)
            ],
            oldReminderToRemoveIndices: [],
            nowDate: formatter.date(from: "2023/10/10 14:30:00")!
        )
        
        // リマインダーをスワイプして削除
        presenter.didSwipeReminderToDelete(index: 0)
        XCTAssertTrue(reminderList.isEmpty)
    }
}
