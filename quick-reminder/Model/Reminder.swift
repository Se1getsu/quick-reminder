//
//  Reminder.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/08.
//

import RealmSwift

class Reminder: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
