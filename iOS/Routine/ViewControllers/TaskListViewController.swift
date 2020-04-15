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
    
    private var viewModel = TaskListViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
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
    
    private func bindViewModel() {
        viewModel.objectWillChange
            .sink(receiveValue: reloadTableView)
            .store(in: &cancellables)
    }
    
    @objc private func didTapAddButton() {
        showTaskView()
    }
    
    private func showTaskView(task: Task? = nil) {
        let viewModel = TaskDetailsViewModel(task: task)
        let rootViewController = TaskViewController(viewModel: viewModel)
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
}

// MARK: - UITableView
extension TaskListViewController {
    enum Section {
        case futureTasks
        case expiredTasks
    }
    
    private func reloadTableView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        snapshot.appendSections([.expiredTasks, .futureTasks])
        snapshot.appendItems(viewModel.expiredTasks, toSection: .expiredTasks)
        snapshot.appendItems(viewModel.futureTasks, toSection: .futureTasks)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Task> {
        let dataSource: UITableViewDiffableDataSource<Section, Task> = TableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, task in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TaskTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! TaskTableViewCell
                let task = self.viewModel.getTask(at: indexPath.row, section: indexPath.section)
                let rowViewModel = TaskViewModel(task: task, index: indexPath.row)
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1, !viewModel.expiredTasks.isEmpty {
            return VStack { Divider().background(Color.gray) }.padding().uiView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1, !viewModel.expiredTasks.isEmpty, !viewModel.futureTasks.isEmpty {
            return 16
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.getTask(at: indexPath.row, section: indexPath.section)
        showTaskView(task: task)
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "") {  (_, _, completion) in
            guard let task = self.dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            self.viewModel.resetTask(at: indexPath.row, section: indexPath.section)
            var snapshot = self.dataSource.snapshot()
            snapshot.reloadItems([task])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            completion(true)
        }
        
        action.backgroundColor = .systemBackground
        action.image = UIImage(named: "Reset")
        let swipeActions = UISwipeActionsConfiguration(actions: [action])

        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "") {  (_, _, completion) in
            guard let task = self.dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            self.viewModel.deleteTask(at: indexPath.row, section: indexPath.section)
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([task])
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: {
                var snapshot = self.dataSource.snapshot()
                snapshot.reloadSections([.expiredTasks, .futureTasks])
                self.dataSource.apply(snapshot, animatingDifferences: false)
            })
            completion(true)
        }
        action.backgroundColor = .systemBackground
        action.image = UIImage(named: "Delete")
        let swipeActions = UISwipeActionsConfiguration(actions: [action])

        return swipeActions
    }
}
