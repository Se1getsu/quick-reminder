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

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
