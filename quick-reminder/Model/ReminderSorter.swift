//
//  ReminderSorter.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/12.
//

import Foundation

protocol ReminderSorterProtocol {
    func sorted(_ reminders: [Reminder]) -> [Reminder]
}

final class ReminderSorter: ReminderSorterProtocol {
    
    func sorted(_ reminders: [Reminder]) -> [Reminder] {
        return reminders.sorted { $0.date < $1.date }
    }
    
}
