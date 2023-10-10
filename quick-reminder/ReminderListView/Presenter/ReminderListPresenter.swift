//
//  ReminderListPresenter.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/10/08
//
//

import Foundation

protocol ReminderListPresenterInput {
    /// 画面に表示するリマインダーの配列。
    var remindersToDisplay: [Reminder] { get }
    
    /// ViewのviewDidLoadで呼び出す処理。
    func viewDidLoad()
    
    /// ViewのviewWillAppearで呼び出す処理。
    func viewWillAppear()
    
    /// リマインダー新規作成ボタンが押された時の処理。
    func didTapAddButton()
    
    /// リマインダーがタップされた時の処理。
    func didTapReminder(index: Int)
    
    /// リマインダーをスワイプして削除するアクションが行われた時の処理。
    func didSwipeReminderToDelete(index: Int)
}

protocol ReminderListPresenterOutput: AnyObject {
    /// Viewを更新する。
    func reloadView()
    
    /// リマインダー編集画面に遷移する。
    /// - parameter editMode: 編集モード。
    /// - parameter delegate: リマインダー編集画面のデリゲート。
    func moveToReminderEditVC(editMode: ReminderEditPresenter.EditMode, delegate: ReminderEditDelegate)
}

final class ReminderListPresenter {
    private weak var view: ReminderListPresenterOutput!
    
    private var reminderList: ReminderListProtocol
    private let notificationHandler: NotificationHandlerProtocol
    private let notificationDateCalculator: NotificationDateCalculator
    private let dateProvider: DateProviderProtocol
    private let oldReminderRemover: OldReminderRemoverProtocol
    
    struct Dependency {
        let reminderList: ReminderListProtocol
        let notificationHandler: NotificationHandlerProtocol
        let notificationDateCalculator: NotificationDateCalculator
        let dateProvider: DateProviderProtocol
        let oldReminderRemover: OldReminderRemoverProtocol
    }
    
    init(dependency: Dependency, view: ReminderListPresenterOutput) {
        self.view = view
        self.reminderList = dependency.reminderList
        self.notificationHandler = dependency.notificationHandler
        self.notificationDateCalculator = dependency.notificationDateCalculator
        self.dateProvider = dependency.dateProvider
        self.oldReminderRemover = dependency.oldReminderRemover
    }
}

extension ReminderListPresenter: ReminderListPresenterInput {
    var remindersToDisplay: [Reminder] {
        reminderList.reminders
    }
    
    func viewDidLoad() {
        reminderList.delegate = self
    }
    
    func viewWillAppear() {
        oldReminderRemover.removeOldReminders(in: &reminderList)
        view.reloadView()
    }
    
    func didTapAddButton() {
        let reminder = Reminder(date: notificationDateCalculator.calculate(from: dateProvider.now))
        view.moveToReminderEditVC(editMode: .create(defaultReminder: reminder), delegate: self)
    }
    
    func didTapReminder(index: Int) {
        let reminder = reminderList.reminders[index]
        view.moveToReminderEditVC(editMode: .update(currentReminder: reminder), delegate: self)
    }
    
    func didSwipeReminderToDelete(index: Int) {
        reminderList.deleteReminder(index: index)
    }
}

extension ReminderListPresenter: ReminderListDelegate {
    func didAddReminder(_ reminder: Reminder) {
        view.reloadView()
        notificationHandler.registerNotification(
            reminder: reminder
        )
    }
    
    func didDeleteReminder(_ reminder: Reminder) {
        view.reloadView()
        notificationHandler.removeNotification(
            reminder: reminder
        )
    }
    
    func didUpdateReminder(_ updatedReminder: Reminder) {
        view.reloadView()
        notificationHandler.registerNotification(
            reminder: updatedReminder
        )
    }
}

extension ReminderListPresenter: ReminderEditDelegate {
    func createReminder(_ reminder: Reminder) {
        try? reminderList.addReminder(reminder: reminder)
    }
    
    func didEditReminder(editedReminder reminder: Reminder) {
        try? reminderList.updateReminder(reminder: reminder)
    }
}
