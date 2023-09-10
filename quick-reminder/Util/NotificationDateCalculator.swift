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
        let now = Date()
        let nowDay = calendar.dateComponents([.day], from: now).day!
        dateComponents.day = date <= now ? nowDay + 1 : nowDay
        return calendar.date(from: dateComponents)!
    }
}
