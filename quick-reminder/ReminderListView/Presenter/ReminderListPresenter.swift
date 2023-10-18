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
    
    /// ViewのviewDidAppearで呼び出す処理。
    func viewDidAppear()
    
    /// ViewのviewWillDisappearで呼び出す処理。
    func viewWillDisappear()
    
    /// リマインダー新規作成ボタンが押された時の処理。
    func didTapAddButton()
    
    /// リマインダーがタップされた時の処理。
    func didTapReminder(index: Int)
    
    /// リマインダーをスワイプして削除するアクションが行われた時の処理。
    func didSwipeReminderToDelete(index: Int)
}

protocol ReminderListPresenterOutput: AnyObject {
    /// Modelにリマインダーが追加されたときの処理。
    func didAddReminder(_ reminder: Reminder, index: Int)
    
    /// Modelでリマインダーが削除されたときの処理。
    func didDeleteReminder(index: Int)
    
    /// Modelでリマインダーのインデックスが移動されたときの処理。
    func didMoveReminder(at fromIndex: Int, to toIndex: Int)
    
    /// Modelのリマインダーの情報を再読み込みする。
    func reloadReminder(index: Int)
    
    /// リマインダーの表示スタイルを切り替える。
    func updateReminderStyle(index: Int, style: ReminderPresentationStyle)
    
    /// リマインダー編集画面に遷移する。
    /// - parameter editMode: 編集モード。
    /// - parameter delegate: リマインダー編集画面のデリゲート。
    func moveToReminderEditVC(editMode: ReminderEditPresenter.EditMode, delegate: ReminderEditDelegate)
}

final class ReminderListPresenter {
    private weak var view: ReminderListPresenterOutput!
    
    private var reminderList: ReminderListProtocol
    private let notificationHandler: NotificationHandlerProtocol
    private let notificationDateCalculator: NotificationDateCalculatorProtocol
    private let dateProvider: DateProviderProtocol
    private let oldReminderFinder: OldReminderFinderProtocol
    
    private var reminderStyleUpdateTimer: Timer?
    
    struct Dependency {
        let reminderList: ReminderListProtocol
        let notificationHandler: NotificationHandlerProtocol
        let notificationDateCalculator: NotificationDateCalculatorProtocol
        let dateProvider: DateProviderProtocol
        let oldReminderFinder: OldReminderFinderProtocol
    }
    
    init(dependency: Dependency, view: ReminderListPresenterOutput) {
        self.view = view
        self.reminderList = dependency.reminderList
        self.notificationHandler = dependency.notificationHandler
        self.notificationDateCalculator = dependency.notificationDateCalculator
        self.dateProvider = dependency.dateProvider
        self.oldReminderFinder = dependency.oldReminderFinder
    }
    
    /// リマインダーの表示スタイルを決める処理。
    private func getReminderStyle(reminder: Reminder) -> ReminderPresentationStyle {
        if reminder.date > dateProvider.now {
            .normal
        } else {
            .notified
        }
    }
    
    /// 各リマインダーの表示スタイルを設定する。
    private func updateReminderStyles() {
        remindersToDisplay.enumerated().forEach { index, reminder in
            let style = getReminderStyle(reminder: reminder)
            view.updateReminderStyle(index: index, style: style)
        }
    }
}

extension ReminderListPresenter: ReminderListPresenterInput {
    var remindersToDisplay: [Reminder] {
        reminderList.reminders
    }
    
    func viewDidLoad() {
        reminderList.delegate = self
    }
    
    func viewDidAppear() {
        updateReminderStyles()
        reminderStyleUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateReminderStyles()
        }
    }
    
    func viewWillDisappear() {
        reminderStyleUpdateTimer?.invalidate()
    }
    
    func viewWillAppear() {
        let oldReminderIndices = oldReminderFinder.getOldReminderIndices(in: reminderList)
        reminderList.deleteReminders(indices: oldReminderIndices)
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
        reminderList.deleteReminders(indices: [index])
    }
}

extension ReminderListPresenter: ReminderListDelegate {
    func didAddReminder(_ reminder: Reminder) {
        notificationHandler.registerNotification(reminder: reminder)
        let index = try! reminderList.getIndex(reminder: reminder)
        view.didAddReminder(reminder, index: index)
    }
    
    func didDeleteReminder(_ reminder: Reminder, index: Int) {
        notificationHandler.removeNotification(reminder: reminder)
        view.didDeleteReminder(index: index)
    }
    
    func didMoveReminder(at fromIndex: Int, to toIndex: Int) {
        view.didMoveReminder(at: fromIndex, to: toIndex)
    }
    
    func didUpdateReminder(_ updatedReminder: Reminder, newIndex index: Int) {
        notificationHandler.registerNotification(reminder: updatedReminder)
        view.reloadReminder(index: index)
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
