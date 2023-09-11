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
        
        func calculateMinuteTime(from date: Date) -> Int {
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            return components.hour! * 60 + components.minute!
        }
        
        let now = Date()
        let nowDay = calendar.dateComponents([.day], from: now).day!
        dateComponents.day = nowDay
        if calculateMinuteTime(from: date) <= calculateMinuteTime(from: now) {
            dateComponents.day! += 1
        }
        return calendar.date(from: dateComponents)!
    }
}
