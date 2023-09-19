//
//  quick_reminderUITests.swift
//  quick-reminderUITests
//
//  Created by 垣本 桃弥 on 2023/09/18.
//

import XCTest
@testable import quick_reminder

final class quick_reminderUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_リマインダーがない時の説明表示() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-useUITestMockRepository")
        app.launch()

        let label = app.staticTexts["No Reminder Description Label"].firstMatch
        XCTAssertTrue(label.exists)
        XCTAssertTrue(label.isHittable)
    }
    
    func test_リマインダー新規作成() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-useUITestMockRepository")
        app.launch()
        
        // 新規作成ボタンの存在を確認
        let addButton = app.buttons["Add Reminder Bar Button"].firstMatch
        XCTAssertTrue(addButton.exists)
        XCTAssertTrue(addButton.isHittable)
        
        addButton.tap()
        
        // 編集画面が表示されることを確認
        let titleTextField = app.textFields["Reminder Title Text Field"].firstMatch
        let timeDatePicker = app.datePickers["Reminder Time Date Picker"].firstMatch
        XCTAssertTrue(titleTextField.exists)
        XCTAssertTrue(titleTextField.isHittable)
        XCTAssertTrue(timeDatePicker.exists)
        XCTAssertTrue(timeDatePicker.isHittable)
        
        // 戻るボタンの存在を確認
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists)
        XCTAssertTrue(backButton.isHittable)
        
        backButton.tap()
        
        // テーブルビューにセルが追加されたことをチェック
        let reminderListTableView = app.tables["Reminder List Table View"].firstMatch
        XCTAssertTrue(reminderListTableView.exists)
        XCTAssertTrue(reminderListTableView.isHittable)
        XCTAssertEqual(reminderListTableView.cells.count, 1)
    }
    
    func test_リマインダー編集() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-useUITestMockRepository")
        app.launch()
        
        // 新規作成
        let addButton = app.buttons["Add Reminder Bar Button"].firstMatch
        addButton.tap()
        
        // 編集
        let titleTextField = app.textFields["Reminder Title Text Field"].firstMatch
        let timeDatePicker = app.datePickers["Reminder Time Date Picker"].firstMatch
        titleTextField.tap()
        titleTextField.typeText("サンプル文字列")
        timeDatePicker.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "12")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "34")
        // timeDatePickerを閉じる
        let coordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.1))
        coordinate.tap()
        
        // 戻るボタンを押す
        let saveButton = app.navigationBars.buttons["Reminder Edit Save Button"].firstMatch
        XCTAssertTrue(saveButton.exists)
        XCTAssertTrue(saveButton.isHittable)
        saveButton.tap()

        // 編集した内容を確認
        let reminderListTableView = app.tables["Reminder List Table View"].firstMatch
        XCTAssertEqual(reminderListTableView.cells.count, 1)
        let cell = reminderListTableView.cells.element(boundBy: 0)
        XCTAssertEqual(cell.staticTexts.element(boundBy: 0).label, "サンプル文字列")
        XCTAssertTrue(cell.staticTexts.element(boundBy: 1).firstMatch.label.contains("12:34"))
    }
    
    func test_リマインダー削除() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-useUITestMockRepository")
        app.launch()
        
        // 新規作成
        let addButton = app.buttons["Add Reminder Bar Button"].firstMatch
        addButton.tap()
        let saveButton = app.navigationBars.buttons["Reminder Edit Save Button"].firstMatch
        saveButton.tap()

        // 削除
        let reminderListTableView = app.tables["Reminder List Table View"].firstMatch
        let cell = reminderListTableView.cells.element(boundBy: 0)
        cell.swipeLeft()
        cell.buttons["ゴミ箱"].tap()
        XCTAssertEqual(reminderListTableView.cells.count, 0)
        
        // リマインダーがない時の説明表示が出るかを確認
        let noReminderLabel = app.staticTexts["No Reminder Description Label"].firstMatch
        XCTAssertTrue(noReminderLabel.exists)
        XCTAssertTrue(noReminderLabel.isHittable)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
