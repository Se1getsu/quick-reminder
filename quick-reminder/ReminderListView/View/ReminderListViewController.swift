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
        reminderTableView.backgroundColor = UIColor(resource: .reminderListTableViewBackground)
        return reminderTableView
    }()
    
    /// テーブルビューに表示する各リマインダーの通知時刻のフォーマッタ。
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "M/d HH:mm"
        return dateFormatter
    }()
    
    private var presenter: ReminderListPresenterInput!
    
    private let dateProvider: DateProviderProtocol
    
    struct Dependency {
        let dateProvider: DateProviderProtocol
    }
    
    init(dependency: Dependency) {
        self.dateProvider = dependency.dateProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inject(presenter: ReminderListPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登録中のリマインダー"
        view.backgroundColor = UIColor(resource: .reminderListTableViewBackground)
        setupNavigationBar()
        presenter.viewDidLoad()
        
        reminderTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(reminderTableView)
        
        NSLayoutConstraint.activate([
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
        reloadView()
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
        cell.backgroundColor = reminder.date <= dateProvider.now ? UIColor(resource: .inactiveReminderCellBackground) : UIColor(resource: .activeReminderCellBackground)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapReminder(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [unowned self] _, _, completionHandler in
            presenter.didSwipeReminderToDelete(index: indexPath.row)
            if presenter.remindersToDisplay.isEmpty {
                reloadView()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


extension ReminderListViewController: ReminderListPresenterOutput {
    func reloadView() {
        reminderTableView.reloadData()
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
