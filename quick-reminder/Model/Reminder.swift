//
//  Reminder.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/08.
//

import RealmSwift

final class Reminder: Object {
    let notificationCenter = NotificationCenter()
    static let defaultTitle = "新規リマインダー"
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = defaultTitle
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func reinit(title: String, date: Date) -> Reminder {
        return Reminder(value: [
            "id": id,
            "title": title,
            "date": date
        ] as [String : Any])
    }
}
