//
//  ReminderListViewController.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/10/08
//
//

import UIKit

class ReminderListViewController: UIViewController {
    /// リマインダーリストを表示するためのテーブルビュー。
    let reminderTableView: UITableView = {
        let reminderTableView = UITableView()
        reminderTableView.accessibilityIdentifier = "Reminder List Table View"
        reminderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        reminderTableView.backgroundColor = .my.primaryBackground
        return reminderTableView
    }()
    
    /// テーブルビューに表示する各リマインダーの通知時刻のフォーマッタ。
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "M/d HH:mm"
        return dateFormatter
    }()
    
    /// 表示するリマインダーがない時に表示するラベル。
    private let noReminderLabel: UILabel = {
        var label = UILabel()
        label.accessibilityIdentifier = "No Reminder Description Label"
        label.text = String(localized: "Press the \"+\" button in the upper right corner of the screen to create a new reminder.")
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var presenter: ReminderListPresenterInput!
    
    func inject(presenter: ReminderListPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "Reminder List", comment: "Navigation bar title")
        view.backgroundColor = .my.secondaryBackground
        setupNavigationBar()
        showOrHideReminderTableIfEmpty()
        presenter.viewDidLoad()
        
        noReminderLabel.translatesAutoresizingMaskIntoConstraints = false
        reminderTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(noReminderLabel)
        view.addSubview(reminderTableView)
        
        NSLayoutConstraint.activate([
            noReminderLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -12),
            noReminderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noReminderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reminderTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reminderTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reminderTableView.topAnchor.constraint(equalTo: view.topAnchor),
            reminderTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        reminderTableView.dataSource = self
        reminderTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = {
            let barButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(didTapAddButton))
            barButton.accessibilityIdentifier = "Add Reminder Bar Button"
            return barButton
        }()
    }
    
    /// 空の時はリマインダーテーブルを非表示にする。
    private func showOrHideReminderTableIfEmpty() {
        let isEmpty = presenter.remindersToDisplay.isEmpty
        noReminderLabel.isHidden = !isEmpty
        reminderTableView.isHidden = isEmpty
    }
    
    /// ナビゲーションバーの＋ボタンが押された時の処理。
    @objc func didTapAddButton() {
        presenter.didTapAddButton()
    }
}

extension ReminderListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.remindersToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let reminder = presenter.remindersToDisplay[indexPath.row]
        let title = reminder.title
        let dateText = dateFormatter.string(from: reminder.date)
        
        var content = cell.defaultContentConfiguration()
        content.text = title
        content.secondaryText = dateText
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapReminder(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [unowned self] _, _, completionHandler in
            presenter.didSwipeReminderToDelete(index: indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


extension ReminderListViewController: ReminderListPresenterOutput {
    func didAddReminder(_ reminder: Reminder, index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        reminderTableView.insertRows(at: [indexPath], with: .automatic)
        showOrHideReminderTableIfEmpty()
    }
    
    func didDeleteReminder(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        reminderTableView.deleteRows(at: [indexPath], with: .automatic)
        showOrHideReminderTableIfEmpty()
    }
    
    func didMoveReminder(at fromIndex: Int, to toIndex: Int) {
        let fromIndexPath = IndexPath(row: fromIndex, section: 0)
        let toIndexPath = IndexPath(row: toIndex, section: 0)
        reminderTableView.moveRow(at: fromIndexPath, to: toIndexPath)
    }
    
    func reloadReminder(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        reminderTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func updateReminderStyle(index: Int, style: ReminderPresentationStyle) {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = reminderTableView.cellForRow(at: indexPath) else { return }
        cell.backgroundColor = style.backgroundColor
    }
    
    func moveToReminderEditVC(editMode: ReminderEditPresenter.EditMode, delegate: ReminderEditDelegate) {
        let vc = ReminderEditViewController()
        let vcPresenter = ReminderEditPresenter(
            dependency: .init(
                notificationDateCalculator: NotificationDateCalculator(dateProvider: DateProvider())
            ),
            view: vc,
            editMode: editMode
        )
        vcPresenter.delegate = delegate
        vc.inject(presenter: vcPresenter)
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
}
