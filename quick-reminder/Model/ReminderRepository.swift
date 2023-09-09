//
//  ReminderRepository.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/08.
//

import RealmSwift

final class ReminderRepository {
    static let shared = ReminderRepository()
    
    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func addReminder(_ reminder: Reminder) {
        try? realm.write {
            realm.add(reminder)
        }
    }

    func updateReminder(_ reminder: Reminder) {
        try? realm.write {
            realm.add(reminder, update: .modified)
        }
    }

    func deleteReminder(_ reminder: Reminder) {
        try? realm.write {
            realm.delete(reminder)
        }
    }

    func getAllReminders() -> Results<Reminder> {
        return realm.objects(Reminder.self)
    }

    func getReminder(withID id: String) -> Reminder? {
        return realm.object(ofType: Reminder.self, forPrimaryKey: id)
    }
    
}
