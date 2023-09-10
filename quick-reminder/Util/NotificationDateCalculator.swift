//
//  NotificationDateCalculator.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/10.
//

import Foundation

final class NotificationDateCalculator {
    static let shared = NotificationDateCalculator()
    
    private init() {}
    
    func calculate(from date: Date) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        if date <= Date() { dateComponents.day! += 1 }
        return calendar.date(from: dateComponents)!
    }
}
