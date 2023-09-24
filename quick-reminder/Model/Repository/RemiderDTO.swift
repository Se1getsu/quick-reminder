//
//  RemiderDTO.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/13.
//

import RealmSwift

/// RealmとReminderデータをやり取りするためのDTO。
final class ReminderDTO: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(from reminder: Reminder) {
        self.init()
        self.id = reminder.id
        self.title = reminder.title
        self.date = reminder.date
    }
    
    /// 自身をReminderに変換したものを返す。
    func convertToReminder() -> Reminder {
        return Reminder(id: id, title: title, date: date)
    }
}
