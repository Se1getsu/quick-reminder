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

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
