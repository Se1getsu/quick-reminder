//
//  ReminderList.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/09.
//

import Foundation

/// Reminder配列の管理を行う。
///
/// 格納されたリマインダーは、
/// - 与えられたリポジトリと同期する。
/// - 与えられたソーターによって、自動的にソートされる。
/// - 与えられたバリデータによって、妥当性が確認される。
final class ReminderList {
    
    let notificationCenter = NotificationCenter()
    
    private let repository: ReminderRepositoryDelegate!
    private let sorter: ReminderSorterProtocol!
    private let validator: ReminderListValidatorProtocol!
    
    private var reminders: [Reminder] = [] {
        didSet {
            reminders = sorter.sorted(reminders)
        }
    }
    /// Reminderリストの要素数
    var count: Int { reminders.count }
    /// Reminderリストが空かを表すブール値。
    var isEmpty: Bool { reminders.isEmpty }
    
    init(_ repository: ReminderRepositoryDelegate,
         _ sorter: ReminderSorterProtocol,
         _ validator: ReminderListValidatorProtocol) {
        self.repository = repository
        self.validator = validator
        self.sorter = sorter
        fetchReminders()
    }
    
    /// リポジトリからデータをフェッチすることでリストを初期化する
    func fetchReminders() {
        reminders = repository.getAllReminders()
    }
    
    /// 与えられたインデックスのReminderを返す
    func getReminder(index: Int) -> Reminder {
        return reminders[index]
    }
    
    /// 与えられたReminderがどのindexで管理されているかを返す。
    ///
    /// 与えられたReminderと一致するIDのReminderがなければ、エラーを投げる。
    func getIndex(reminder: Reminder) throws -> Int {
        try validator.validateContains(reminders: reminders, newReminder: reminder)
        return reminders.firstIndex { $0.id == reminder.id }!
    }
    
    /// 与えられたReminderをリストに追加する
    func addReminder(reminder: Reminder) throws {
        try validator.validateNotContained(reminders: reminders, newReminder: reminder)
        repository.addReminder(reminder)
        reminders.append(reminder)
        notificationCenter.post(name: .init("didAddReminder"), object: nil, userInfo: ["reminder": reminder])
    }
    
    /// 与えられたインデックスのReminderをリストから削除する
    func deleteReminder(index: Int) {
        let reminder = reminders.remove(at: index)
        repository.deleteReminder(reminder)
        notificationCenter.post(name: .init("didDeleteReminder"), object: nil, userInfo: ["reminder": reminder])
    }
    
    /// 与えられたReminderをリストから削除する
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
        notificationCenter.post(name: .init("didUpdateReminder"), object: nil, userInfo: ["reminder": reminder])
    }
    
    /// (n, x)のペアのシーケンスを返す。nはゼロから始まる連続した整数を表し、xはReminderListの要素を表す。
    func enumerated() -> EnumeratedSequence<[Reminder]> {
        return reminders.enumerated()
    }
    
}
