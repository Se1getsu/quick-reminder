//
//  Reminder.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/08.
//

import RealmSwift

final class Reminder: Object {
    let notificationCenter = NotificationCenter()
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = "" {
        didSet { notificationCenter.post(name: .init(rawValue: "didChange"), object: nil) }
    }
    @objc dynamic var date: Date = Date() {
        didSet { notificationCenter.post(name: .init(rawValue: "didChange"), object: nil) }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
