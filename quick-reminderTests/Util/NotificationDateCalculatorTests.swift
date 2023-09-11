//
//  NotificationDateCalculatorTests.swift
//  quick-reminderTests
//
//  Created by 垣本 桃弥 on 2023/09/11.
//

import XCTest
@testable import quick_reminder

final class NotificationDateCalculatorTests: XCTestCase {
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    func testCalculation(nowDate: Date, targetTime: Date, expected: Date) throws {
        let dateProvider = MockDateProvider(now: nowDate)
        NotificationDateCalculator.setUp(dateProvider)
        let result = NotificationDateCalculator.shared.calculate(from: targetTime)
        XCTAssertEqual(result, expected)
    }
    
    func test_時刻が過去の場合は翌日の日付になる() throws {
        try! testCalculation(
            nowDate:    formatter.date(from: "2023/10/10 14:00:00")!,
            targetTime: formatter.date(from: "1000/01/01 00:00:00")!,
            expected:   formatter.date(from: "2023/10/11 00:00:00")!
        )
    }
    
    func test_時刻が同時刻の場合は翌日の日付になる() throws {
        try! testCalculation(
            nowDate:    formatter.date(from: "2023/10/10 14:00:00")!,
            targetTime: formatter.date(from: "1000/01/01 14:00:00")!,
            expected:   formatter.date(from: "2023/10/11 14:00:00")!
        )
    }
    
    func test_時刻が同時刻直後の場合は同じ日付になる() throws {
        try! testCalculation(
            nowDate:    formatter.date(from: "2023/10/10 14:00:00")!,
            targetTime: formatter.date(from: "1000/01/01 14:01:00")!,
            expected:   formatter.date(from: "2023/10/10 14:01:00")!
        )
    }
    
    func test_時刻が未来の場合は同じ日付になる() throws {
        try! testCalculation(
            nowDate:    formatter.date(from: "2023/10/10 14:00:00")!,
            targetTime: formatter.date(from: "1000/01/01 23:59:00")!,
            expected:   formatter.date(from: "2023/10/10 23:59:00")!
        )
    }
    
    func test_戻り値に分以下の情報は含まれない() throws {
        try! testCalculation(
            nowDate:    formatter.date(from: "2023/10/10 14:00:32")!,
            targetTime: formatter.date(from: "1000/01/01 00:00:59")!,
            expected:   formatter.date(from: "2023/10/11 00:00:00")!
        )
    }
    
    func test_大晦日は翌日が翌年となる() throws {
        try! testCalculation(
            nowDate:    formatter.date(from: "2023/12/31 14:00:00")!,
            targetTime: formatter.date(from: "1000/01/01 12:00:00")!,
            expected:   formatter.date(from: "2024/01/01 12:00:00")!
        )
    }

}
