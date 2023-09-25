//
//  Reminder.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/08.
//

import RealmSwift

/// リマインダーの情報を保持する値オブジェクト。
struct Reminder {
    static let defaultTitle = "新規リマインダー"
    
    let id: String
    let title: String
    let date: Date
    
    init(id: String = UUID().uuidString,
         title: String = defaultTitle,
         date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }
    
    func reinit(title: String, date: Date) -> Reminder {
        Reminder(id: self.id, title: title, date: date)
    }
}
