//
//  TaskListViewController.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI
import SnapKit
import Combine

final class TableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

final class TaskListViewController: UITableViewController {
    
    private let viewModel: TaskListViewModel
    private lazy var dataSource = makeDataSource()
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onTaskUpdate),
                                               name: .onTaskUpdate,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Routine"
        tableView.separatorStyle = .none
        tableView.register(TaskTableViewCell.self,
                           forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.dataSource = dataSource
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationController?.navigationBar.tintColor = .label
    }
    
    @objc private func onTaskUpdate() {
        reloadTableView()
    }

    @objc private func didTapAddButton() {
        showTaskView()
    }
    
    private func showTaskView(task: Task? = nil) {
        let viewModel = TaskDetailsViewModel(
            task: task,
            repository: self.viewModel.repository,
            taskNotificationCenter: self.viewModel.taskNotificationCenter
        )
        let rootViewController = TaskViewController(viewModel: viewModel)
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
}

// MARK: - UITableView
private extension TaskListViewController {
    
    func reloadDataSource(animated: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TaskViewModel>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems(viewModel.expiredTasks, toSection: 0)
        snapshot.appendItems(viewModel.futureTasks, toSection: 1)
        dataSource.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
    
    func reloadTableView() {
        viewModel.refreshData()
        reloadDataSource(completion: reloadColors)
    }
    
    func reloadColors() {
        viewModel.reloadColors()
        reloadDataSource(animated: false)
    }

    func resetTableViewItem(atIndexPath indexPath: IndexPath) {
        viewModel.resetTask(at: indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: reloadTableView)
    }
    
    func deleteTableViewItem(atIndexPath indexPath: IndexPath) {
        guard let task = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        viewModel.deleteTask(at: indexPath)
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([task])
        dataSource.apply(snapshot, animatingDifferences: true, completion: reloadColors)
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Int, TaskViewModel> {
        let dataSource: UITableViewDiffableDataSource<Int, TaskViewModel> = TableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, task in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TaskTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! TaskTableViewCell
                let rowViewModel = self.viewModel.getTask(at: indexPath)
                cell.host(TaskRowView(viewModel: rowViewModel), parent: self)
                return cell
            }
        )
        dataSource.defaultRowAnimation = .right
        return dataSource
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController {
    
    private func hasHeader(section: Int) -> Bool {
        return section == 1 && !viewModel.expiredTasks.isEmpty && !viewModel.futureTasks.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if hasHeader(section: section) {
            return VStack { Divider().background(Color.gray) }.padding().uiView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if hasHeader(section: section) {
            return 16
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.getTask(at: indexPath).task
        showTaskView(task: task)
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "") {  (_, _, completion) in
            self.resetTableViewItem(atIndexPath: indexPath)
            completion(true)
        }
        
        action.backgroundColor = .systemBackground
        action.image = UIImage(named: "Reset")

        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "") {  (_, _, completion) in
            self.deleteTableViewItem(atIndexPath: indexPath)
            completion(true)
        }
        
        action.backgroundColor = .systemBackground
        action.image = UIImage(named: "Delete")

        return UISwipeActionsConfiguration(actions: [action])
    }
}
