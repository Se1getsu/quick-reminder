//
//  ReminderListViewController.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/06.
//

import UIKit

final class ReminderListViewController: UIViewController {
    private let reminderListView = ReminderListView()
    private let noReminderView = NoReminderView()
    
    private var reminderList: ReminderListProtocol!
    private let notificationHandler: NotificationHandlerProtocol!
    private let notificationDateCalculator: NotificationDateCalculator!
    private let dateProvider: DateProviderProtocol!
    private let oldReminderRemover: OldReminderRemoverProtocol!
    
    struct Dependency {
        let reminderList: ReminderListProtocol
        let notificationHandler: NotificationHandlerProtocol
        let notificationDateCalculator: NotificationDateCalculator
        let dateProvider: DateProviderProtocol
        let oldReminderRemover: OldReminderRemoverProtocol
    }
    
    /// テーブルビューに表示する各リマインダーの通知時刻のフォーマッタ。
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M/d HH:mm"
        return dateFormatter
    }()
    
    init(dependency: Dependency) {
        self.reminderList = dependency.reminderList
        self.notificationHandler = dependency.notificationHandler
        self.notificationDateCalculator = dependency.notificationDateCalculator
        self.dateProvider = dependency.dateProvider
        self.oldReminderRemover = dependency.oldReminderRemover
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登録中のリマインダー"
        setupNavigationBar()
        
        reminderListView.reminderTableView.dataSource = self
        reminderListView.reminderTableView.delegate = self
        
        reminderList.notificationCenter.addObserver(forName: .didAddReminder, object: nil, queue: nil) { [unowned self] notification in
            self.reloadView()
            notificationHandler.registerNotification(
                reminder: notification.userInfo!["reminder"] as! Reminder
            )
        }
        reminderList.notificationCenter.addObserver(forName: .didDeleteReminder, object: nil, queue: nil) { [unowned self] notification in
            notificationHandler.removeNotification(
                reminder: notification.userInfo!["reminder"] as! Reminder
            )
        }
        reminderList.notificationCenter.addObserver(forName: .didUpdateReminder, object: nil, queue: nil) { [unowned self] notification in
            self.reloadView()
            notificationHandler.registerNotification(
                reminder: notification.userInfo!["reminder"] as! Reminder
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        oldReminderRemover.removeOldReminders(in: &reminderList)
        reloadView()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = {
            let barButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addButtonTapped))
            barButton.accessibilityIdentifier = "Add Reminder Bar Button"
            return barButton
        }()
    }
    
    /// ナビゲーションバーの＋ボタンが押された時の処理。
    @objc func addButtonTapped() {
        let reminder = Reminder(date: notificationDateCalculator.calculate(from: dateProvider.now))
        pushToReminderEditVC(editMode: .create(defaultReminder: reminder))
    }
    
    /// viewを更新する。
    func reloadView() {
        if reminderList.isEmpty {
            view = noReminderView
        } else {
            view = reminderListView
            reminderListView.reminderTableView.reloadData()
        }
    }
    
    /// ReminderEditViewに画面遷移する。
    ///
    /// - parameter editMode: 編集モード。
    func pushToReminderEditVC(editMode: ReminderEditViewController.EditMode) {
        let vc = ReminderEditViewController(
            dependency: .init(
                notificationDateCalculator: NotificationDateCalculator(dateProvider: DateProvider())
            ),
            editMode: editMode
        )
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
}

extension ReminderListViewController: ReminderEditDelegate {
    func createReminder(_ reminder: Reminder) {
        try? reminderList.addReminder(reminder: reminder)
    }
    
    func didEditReminder(editedReminder reminder: Reminder) {
        try? reminderList.updateReminder(reminder: reminder)
    }
}

extension ReminderListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let reminder = reminderList.getReminder(index: indexPath.row)
        let title = reminder.title
        let dateText = dateFormatter.string(from: reminder.date)
        
        var content = cell.defaultContentConfiguration()
        content.text = title
        content.secondaryText = dateText
        cell.contentConfiguration = content
        cell.backgroundColor = reminder.date <= dateProvider.now ? UIColor(resource: .inactiveReminderCellBackground) : UIColor(resource: .activeReminderCellBackground)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let reminder = reminderList.getReminder(index: indexPath.row)
        pushToReminderEditVC(editMode: .update(currentReminder: reminder))
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [unowned self] _, _, completionHandler in
            self.reminderList.deleteReminder(index: indexPath.row)
            if reminderList.isEmpty {
                self.reloadView()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
