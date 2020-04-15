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
    
    private let viewModel = TaskListViewModel()
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
        reloadTableView()
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, TaskViewModel>()
        snapshot.appendSections([.expiredTasks, .futureTasks])
        snapshot.appendItems(viewModel.expiredTasks, toSection: .expiredTasks)
        snapshot.appendItems(viewModel.futureTasks, toSection: .futureTasks)
        dataSource.apply(snapshot, animatingDifferences: true, completion: reloadSections)
    }
    
    private func resetTableViewItem(atIndexPath indexPath: IndexPath) {
        viewModel.resetTask(at: indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: reloadTableView)
    }
    
    //Using for reloading colors
    private func reloadSections() {
        var snpashot = dataSource.snapshot()
        snpashot.reloadSections([.expiredTasks, .futureTasks])
        dataSource.apply(snpashot, animatingDifferences: false)
    }
    
    private func deleteTableViewItem(atIndexPath indexPath: IndexPath) {
        guard let task = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        viewModel.deleteTask(at: indexPath)
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([task])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, TaskViewModel> {
        let dataSource: UITableViewDiffableDataSource<Section, TaskViewModel> = TableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, task in
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
