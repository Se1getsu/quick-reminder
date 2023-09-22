//
//  ReminderList.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/09.
//

import Foundation

extension Notification.Name {
    /// ReminderListにReminderが追加された時にpostされる通知。
    static let didAddReminder = Notification.Name("ReminderList.didAddReminder")
    /// ReminderListからReminderが削除された時にpostされる通知。
    static let didDeleteReminder = Notification.Name("ReminderList.didDeleteReminder")
    /// ReminderList内のReminderが更新された時にpostされる通知。
    static let didUpdateReminder = Notification.Name("ReminderList.didUpdateReminder")
}

/// Reminder配列の管理を行うためのメソッド。
protocol ReminderListProtocol {
    var notificationCenter: NotificationCenter { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    
    func fetchReminders()
    func getReminder(index: Int) -> Reminder
    func getIndex(reminder: Reminder) throws -> Int
    func addReminder(reminder: Reminder) throws
    func deleteReminder(index: Int)
    func deleteReminder(reminder: Reminder) throws
    func updateReminder(reminder: Reminder) throws
    func enumerated() -> EnumeratedSequence<[Reminder]>
}

/// Reminder配列の管理を行う。
///
/// 格納されたリマインダーは、
/// - 与えられたリポジトリと同期する。
/// - 与えられたソーターによって、自動的にソートされる。
/// - 与えられたバリデータによって、妥当性が確認される。
final class ReminderList: ReminderListProtocol {
    
    let notificationCenter = NotificationCenter()
    
    private let repository: ReminderRepositoryProtocol!
    private let sorter: ReminderSorterProtocol!
    private let validator: ReminderListValidatorProtocol!
    
    private var reminders: [Reminder] = [] {
        didSet {
            reminders = sorter.sorted(reminders)
        }
    }
    /// Reminderリストの要素数。
    var count: Int { reminders.count }
    /// Reminderリストが空かを表すブール値。
    var isEmpty: Bool { reminders.isEmpty }
    
    init(repository: ReminderRepositoryProtocol,
         sorter: ReminderSorterProtocol,
         validator: ReminderListValidatorProtocol) {
        self.repository = repository
        self.validator = validator
        self.sorter = sorter
        fetchReminders()
    }
    
    /// リポジトリからデータをフェッチすることでリストを初期化する。
    func fetchReminders() {
        reminders = repository.getAllReminders()
    }
    
    /// 与えられたインデックスのReminderを返す。
    func getReminder(index: Int) -> Reminder {
        return reminders[index]
    }
    
    /// 与えられたReminderがどのindexで管理されているかを返す。
    ///
    /// 与えられたReminderと一致するIDのReminderがなければ、エラーを投げる。
    func getIndex(reminder: Reminder) throws -> Int {
        try validator.validateContains(reminder, in: reminders)
        return reminders.firstIndex { $0.id == reminder.id }!
    }
    
    /// 与えられたReminderをリストに追加する。
    func addReminder(reminder: Reminder) throws {
        try validator.validateNotContains(reminder, in: reminders)
        repository.addReminder(reminder)
        reminders.append(reminder)
        notificationCenter.post(name: .didAddReminder, object: nil, userInfo: ["reminder": reminder])
    }
    
    /// 与えられたインデックスのReminderをリストから削除する。
    func deleteReminder(index: Int) {
        let reminder = reminders.remove(at: index)
        repository.deleteReminder(reminder)
        notificationCenter.post(name: .didDeleteReminder, object: nil, userInfo: ["reminder": reminder])
    }
    
    /// 与えられたReminderをリストから削除する。
    func deleteReminder(reminder: Reminder) throws {
        let index = try getIndex(reminder: reminder)
        deleteReminder(index: index)
    }
    
    /// リスト内のReminderを更新する。
    ///
    /// 与えられたReminderと一致するIDのReminderがなければ、エラーを投げる。
    func updateReminder(reminder: Reminder) throws {
        let index = try getIndex(reminder: reminder)
        repository.updateReminder(reminder)
        reminders[index] = reminder
        notificationCenter.post(name: .didUpdateReminder, object: nil, userInfo: ["reminder": reminder])
    }
    
    /// (n, x)のペアのシーケンスを返す。nはゼロから始まる連続した整数を表し、xはReminderListの要素を表す。
    func enumerated() -> EnumeratedSequence<[Reminder]> {
        return reminders.enumerated()
    }
    
}
