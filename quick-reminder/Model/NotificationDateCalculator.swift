//
//  NotificationDateCalculator.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/10.
//

import Foundation

/// 時刻から、リマインダーの通知日時を計算するためのメソッド。
protocol NotificationDateCalculatorProtocol {
    /// 指定された時間から、通知を行う日時を計算する。
    /// - parameter date: 通知を行う時刻の情報を持つ日時。
    /// - returns: 計算結果となる日時。
    func calculate(from date: Date) -> Date
}

/// 現在時刻から24時間までの範囲内になるように日付を調整したものを計算する。
struct NotificationDateCalculator: NotificationDateCalculatorProtocol {
    private let dateProvider: DateProviderProtocol
    
    init(dateProvider: DateProviderProtocol) {
        self.dateProvider = dateProvider
    }
    
    func calculate(from date: Date) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        func calculateMinuteTime(from date: Date) -> Int {
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            return components.hour! * 60 + components.minute!
        }
        
        let now = dateProvider.now
        let nowComponents = calendar.dateComponents([.year, .month, .day], from: now)
        dateComponents.year = nowComponents.year!
        dateComponents.month = nowComponents.month!
        dateComponents.day = nowComponents.day!
        if calculateMinuteTime(from: date) <= calculateMinuteTime(from: now) {
            dateComponents.day! += 1
        }
        return calendar.date(from: dateComponents)!
    }
}
