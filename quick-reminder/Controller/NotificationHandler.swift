//
//  NotificationHandler.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/12.
//

import Foundation
import UserNotifications

protocol NotificationHandlerProtocol {
    func registerNotification(reminder: Reminder)
    func removeNotification(reminder: Reminder)
}

struct NotificationHandler: NotificationHandlerProtocol {
    
    func registerNotification(reminder: Reminder) {
        let identifier = reminder.id
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "クイックリマインダー"
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
    
    func removeNotification(reminder: Reminder) {
        let identifier = reminder.id
        
        // 通知リクエストを削除
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
