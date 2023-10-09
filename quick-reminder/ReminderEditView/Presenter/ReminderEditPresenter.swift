//
//  ReminderEditPresenter.swift
//  quick-reminder
//  
//  Created by Seigetsu on 2023/10/03
//  
//

import Foundation

protocol ReminderEditPresenterInput {
    /// リマインダーのタイトルを入力するUIに設定するプレースホルダー。
    var reminderTitlePlaceHodler: String { get }
    
    /// ViewのviewDidLoadで呼び出す処理。
    func viewDidLoad()
    
    /// 編集保存のボタンがタップされた時の処理。
    /// - parameter title: 入力されたリマインダータイトル。
    /// - parameter date: 入力されたリマインダー時刻。
    func saveButtonTapped(title: String, date: Date)
    
    /// 編集キャンセルのボタンがタップされた時の処理。
    /// - parameter title: 入力されたリマインダータイトル。
    /// - parameter date: 入力されたリマインダー時刻。
    func cancelButtonTapped(title: String, date: Date)
    
    /// 編集キャンセルのアラートで変更内容破棄ボタンがタップされた時の処理。
    func discardButtonOnCancelAlertTapped()
}

protocol ReminderEditPresenterOutput: AnyObject {
    /// ナビゲーションバーにタイトルを表示する処理。
    func setTitle(_: String)
    
    /// 画面をdismissさせる処理。
    func dismissView()
    
    /// リマインダーの情報を画面上にセットアップする処理。
    func setUpReminderOnView(title: String, date: Date)
    
    /// 編集キャンセルのボタンがタップされた時のアラートを表示する。
    /// - parameter message: アラートメッセージ
    func showCancelAlert(message: String)
}

/// リマインダーの編集結果に対して処理を行うメソッド。
protocol ReminderEditDelegate: AnyObject {
    func createReminder(_ reminder: Reminder)
    func didEditReminder(editedReminder: Reminder)
}

final class ReminderEditPresenter {
    /// リマインダー編集画面の編集モード。
    ///
    /// リマインダー編集画面の初期化のために必要な情報を持つ。
    enum EditMode {
        /// リマインダーを新規作成するための編集モード。
        case create(defaultReminder: Reminder)
        /// 既存のリマインダーを更新するための編集モード。
        case update(currentReminder: Reminder)
        
        /// セットされているリマインダー。
        var reminder: Reminder {
            switch self {
            case .create(defaultReminder: let defaultReminder): return defaultReminder
            case .update(currentReminder: let currentReminder): return currentReminder
            }
        }
        
        /// ナビゲーションバーのタイトル。
        var title: String {
            switch self {
            case .create:   return "新規作成"
            case .update:   return "編集"
            }
        }
        
        /// キャンセル時のアラートメッセージ。
        var cancelAlertMessage: String {
            switch self {
            case .create:   return "この新規リマインダーを破棄しますか？"
            case .update:   return "この変更を破棄しますか？"
            }
        }
    }
    
    private weak var view: ReminderEditPresenterOutput!
    /// リマインダー編集画面のデリゲートとして動作するオブジェクト。
    weak var delegate: ReminderEditDelegate?
    
    private var notificationDateCalculator: NotificationDateCalculator
    
    struct Dependency {
        let notificationDateCalculator: NotificationDateCalculator
    }
    
    private var editMode: EditMode
    
    /// - parameter editMode: 編集モード。
    init(dependency: Dependency, view: ReminderEditPresenterOutput, editMode: EditMode) {
        self.notificationDateCalculator = dependency.notificationDateCalculator
        self.view = view
        self.editMode = editMode
    }
    
    /// ビューがセットアップされてから変更されたかを返す。
    private func didChangeReminderOnView(title inputTitle: String, date inputDate: Date) -> Bool {
        let reminder = editMode.reminder
        
        // タイトル
        let title = inputTitle.isEmpty ? Reminder.defaultTitle : inputTitle
        if title != reminder.title { return true }
        
        // 通知時間
        let originalTime = reminder.date
        let calendar = Calendar.current
        let originalComponents = calendar.dateComponents([.hour, .minute], from: originalTime)
        let editedComponents = calendar.dateComponents([.hour, .minute], from: inputDate)
        if originalComponents != editedComponents { return true }
        
        return false
    }
}

extension ReminderEditPresenter: ReminderEditPresenterInput {
    var reminderTitlePlaceHodler: String {
        Reminder.defaultTitle
    }
    
    func viewDidLoad() {
        view.setTitle(editMode.title)
        
        let reminder = editMode.reminder
        view.setUpReminderOnView(
            title: reminder.title == Reminder.defaultTitle ? "" : reminder.title,
            date: reminder.date
        )
    }
    
    func cancelButtonTapped(title inputTitle: String, date inputDate: Date) {
        if !didChangeReminderOnView(title: inputTitle, date: inputDate) {
            view.dismissView()
        } else {
            view.showCancelAlert(message: editMode.cancelAlertMessage)
        }
    }
    
    func saveButtonTapped(title inputTitle: String, date inputDate: Date) {
        let title = inputTitle.isEmpty ? Reminder.defaultTitle : inputTitle
        let date = notificationDateCalculator.calculate(from: inputDate)
        
        let newReminder = editMode.reminder.reinit(title: title, date: date)
        switch editMode {
        case .create:   delegate?.createReminder(newReminder)
        case .update:   delegate?.didEditReminder(editedReminder: newReminder)
        }
        view.dismissView()
    }
    
    func discardButtonOnCancelAlertTapped() {
        view.dismissView()
    }
}
