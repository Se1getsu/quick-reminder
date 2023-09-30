//
//  ReminderList.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/09.
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
    /// Reminderリストの要素数。
    var count: Int { get }
    /// Reminderリストが空かを表すブール値。
    var isEmpty: Bool { get }
    
    /// リポジトリからデータをフェッチすることでリストを初期化する。
    func fetchReminders()
    
    /// 与えられたインデックスのReminderを返す。
    func getReminder(index: Int) -> Reminder
    
    /// 与えられたReminderがどのindexで管理されているかを返す。
    ///
    /// 与えられたReminderと一致するIDのReminderがなければ、エラーを投げる。
    func getIndex(reminder: Reminder) throws -> Int
    
    /// 与えられたReminderをリストに追加する。
    ///
    /// 与えられたReminderと一致するIDのReminderが既に含まれている場合、エラーを投げる。
    func addReminder(reminder: Reminder) throws
    
    /// 与えられたインデックスのReminderをリストから削除する。
    func deleteReminder(index: Int)
    
    /// 与えられたReminderをリストから削除する。
    ///
    /// 与えられたReminderと一致するIDのReminderがなければ、エラーを投げる。
    func deleteReminder(reminder: Reminder) throws
    
    /// リスト内のReminderを更新する。
    ///
    /// 与えられたReminderと一致するIDのReminderがなければ、エラーを投げる。
    func updateReminder(reminder: Reminder) throws
    
    /// (n, x)のペアのシーケンスを返す。nはゼロから始まる連続した整数を表し、xはReminderListの要素を表す。
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
            reminders = sorter.sorted(reminders: reminders)
        }
    }
    var count: Int { reminders.count }
    var isEmpty: Bool { reminders.isEmpty }
    
    init(repository: ReminderRepositoryProtocol,
         sorter: ReminderSorterProtocol,
         validator: ReminderListValidatorProtocol) {
        self.repository = repository
        self.validator = validator
        self.sorter = sorter
        fetchReminders()
    }
    
    func fetchReminders() {
        reminders = repository.getAllReminders()
    }
    
    func getReminder(index: Int) -> Reminder {
        reminders[index]
    }
    
    func getIndex(reminder: Reminder) throws -> Int {
        try validator.validateContains(reminder, in: reminders)
        return reminders.firstIndex { $0.id == reminder.id }!
    }
    
    func addReminder(reminder: Reminder) throws {
        try validator.validateNotContains(reminder, in: reminders)
        repository.addReminder(reminder)
        reminders.append(reminder)
        notificationCenter.post(name: .didAddReminder, object: nil, userInfo: ["reminder": reminder])
    }
    
    func deleteReminder(index: Int) {
        let reminder = reminders.remove(at: index)
        repository.deleteReminder(reminder)
        notificationCenter.post(name: .didDeleteReminder, object: nil, userInfo: ["reminder": reminder])
    }
    
    func deleteReminder(reminder: Reminder) throws {
        let index = try getIndex(reminder: reminder)
        deleteReminder(index: index)
    }
    
    func updateReminder(reminder: Reminder) throws {
        let index = try getIndex(reminder: reminder)
        repository.updateReminder(reminder)
        reminders[index] = reminder
        notificationCenter.post(name: .didUpdateReminder, object: nil, userInfo: ["reminder": reminder])
    }
    
    func enumerated() -> EnumeratedSequence<[Reminder]> {
        reminders.enumerated()
    }
}
