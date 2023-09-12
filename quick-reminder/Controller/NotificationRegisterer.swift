//
//  NotificationRegisterer.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/12.
//

import Foundation
import UserNotifications

protocol NotificationRegistererProtocol {
    func register(_ reminder: Reminder)
}

struct NotificationRegisterer: NotificationRegistererProtocol {
    
    func register(_ reminder: Reminder) {
        
        print("REGISTER: \(reminder)")
        
        let identifier = reminder.id
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "タイトル"
        content.subtitle = "サブタイトル"
        content.body = reminder.title
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger)

        // 通知リクエストを登録
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
             if let error = error {
                  print(error.localizedDescription)
             }
        }
    }
    
}
