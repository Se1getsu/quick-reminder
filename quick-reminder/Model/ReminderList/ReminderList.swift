//
//  ReminderList.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/09.
//

import Foundation

/// Reminder配列の管理を行うためのメソッド。
protocol ReminderListProtocol {
    /// 格納しているReminderの配列。
    var reminders: [Reminder] { get }
    /// Reminderリストの要素数。
    var count: Int { get }
    /// Reminderリストが空かを表すブール値。
    var isEmpty: Bool { get }
    /// Reminderリストのデリゲートとして動作するオブジェクト。
    var delegate: ReminderListDelegate? { get set }
    
    /// リポジトリからデータをフェッチすることでリストを初期化する。
    func fetchReminders()
    
    /// 与えられたReminderがどのindexで管理されているかを返す。
    ///
    /// 与えられたReminderと一致するIDのReminderがなければ、エラーを投げる。
    func getIndex(reminder: Reminder) throws -> Int
    
    /// 与えられたReminderをリストに追加する。
    ///
    /// 与えられたReminderと一致するIDのReminderが既に含まれている場合、エラーを投げる。
    func addReminder(reminder: Reminder) throws
    
    /// 与えられたインデックスのReminderをリストから削除する。
    func deleteReminders(indices: [Int])
    
    /// リスト内のReminderを更新する。
    ///
    /// 与えられたReminderと一致するIDのReminderがなければ、エラーを投げる。
    func updateReminder(reminder: Reminder) throws
    
    /// (n, x)のペアのシーケンスを返す。nはゼロから始まる連続した整数を表し、xはReminderListの要素を表す。
    func enumerated() -> EnumeratedSequence<[Reminder]>
}

protocol ReminderListDelegate: AnyObject {
    /// ReminderListにReminderが追加された時に呼び出される。
    func didAddReminder(_ reminder: Reminder)
    /// ReminderList内のReminderが削除された時に呼び出される。
    func didDeleteReminder(_ reminder: Reminder, index: Int)
    /// ReminderList内のReminderが別のインデックスに移動した時に呼び出される。
    func didMoveReminder(at fromIndex: Int, to toIndex: Int)
    /// ReminderList内のReminderが更新された時に呼び出される。
    func didUpdateReminder(_ updatedReminder: Reminder, newIndex index: Int)
}

/// Reminder配列の管理を行う。
///
/// 格納されたリマインダーは、
/// - 与えられたリポジトリと同期する。
/// - 与えられたソーターによって、自動的にソートされる。
/// - 与えられたバリデータによって、妥当性が確認される。
final class ReminderList: ReminderListProtocol {
    private let repository: ReminderRepositoryProtocol
    private let sorter: ReminderSorterProtocol
    private let validator: ReminderListValidatorProtocol
    
    private(set) var reminders: [Reminder] = [] {
        didSet {
            reminders = sorter.sorted(reminders: reminders)
        }
    }
    var count: Int { reminders.count }
    var isEmpty: Bool { reminders.isEmpty }
    
    weak var delegate: ReminderListDelegate?
    
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
    
    func getIndex(reminder: Reminder) throws -> Int {
        try validator.validateContains(reminder, in: reminders)
        return reminders.firstIndex { $0.id == reminder.id }!
    }
    
    func addReminder(reminder: Reminder) throws {
        try validator.validateNotContains(reminder, in: reminders)
        
        repository.addReminder(reminder)
        reminders.append(reminder)
        
        delegate?.didAddReminder(reminder)
    }
    
    private func deleteReminder(index: Int) {
        let reminder = reminders.remove(at: index)
        repository.deleteReminder(reminder)
        
        delegate?.didDeleteReminder(reminder, index: index)
    }
    
    func deleteReminders(indices: [Int]) {
        // 他のインデックスが変動しないように、逆順のインデックスで削除する。
        indices.sorted().reversed().forEach { index in
            deleteReminder(index: index)
        }
    }
    
    func updateReminder(reminder: Reminder) throws {
        let index = try getIndex(reminder: reminder)
        
        repository.updateReminder(reminder)
        reminders[index] = reminder
        
        let newIndex = try! getIndex(reminder: reminder)
        delegate?.didMoveReminder(at: index, to: newIndex)
        delegate?.didUpdateReminder(reminder, newIndex: newIndex)
    }
    
    func enumerated() -> EnumeratedSequence<[Reminder]> {
        reminders.enumerated()
    }
}
