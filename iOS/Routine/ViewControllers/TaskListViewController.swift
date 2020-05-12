//
//  TaskListViewController.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI
import SwipeCellKit

final class TaskListViewController: UITableViewController {
    
    private lazy var viewModel = TaskListViewModel()
    private lazy var dataSource = makeDataSource()
    
    private let inactiveResetImage = UIImage(named: "reset_inactive")
    private let activeResetImage = UIImage(named: "reset_active")
    private let inactiveDeleteImage = UIImage(named: "delete_inactive")
    private let activeDeleteImage = UIImage(named: "delete_active")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
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
        let viewModel = TaskDetailsViewModel(task: task)
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
        let dataSource: UITableViewDiffableDataSource<Int, TaskViewModel> = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, task in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TaskTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! TaskTableViewCell
                let rowViewModel = self.viewModel.getTask(at: indexPath)
                cell.host(TaskRowView(viewModel: rowViewModel), parent: self)
                cell.delegate = self
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
}

extension TaskListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        switch orientation {
        case .left:
            let reseteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                self.resetTableViewItem(atIndexPath: indexPath)
            }

            reseteAction.hidesWhenSelected = false
            reseteAction.backgroundColor = .systemBackground
            reseteAction.image = inactiveResetImage
            reseteAction.highlightedBackgroundColor = .systemBackground
            
            return [reseteAction]
        case .right:
            let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
//                let message = "Are you sure you want to delete the task?"
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    
                alert.addAction(.init(title: "Cancel", style: .cancel))
                alert.addAction(.init(title: "Delete", style: .destructive, handler: { _ in
                    self.deleteTableViewItem(atIndexPath: indexPath)
                }))
                    
                self.present(alert, animated: true, completion: nil)
            }
            
            deleteAction.hidesWhenSelected = false
            deleteAction.backgroundColor = .systemBackground
            deleteAction.image = inactiveDeleteImage
            deleteAction.highlightedBackgroundColor = .systemBackground
            
            return [deleteAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        options.expansionDelegate = self
        options.backgroundColor = .systemBackground
        return options
    }
}

extension TaskListViewController: SwipeExpanding {
    func animationTimingParameters(buttons: [UIButton], expanding: Bool) -> SwipeExpansionAnimationTimingParameters {
        return .default
    }
    
    func actionButton(_ button: UIButton, didChange expanding: Bool, otherActionButtons: [UIButton]) {
        if expanding {
            if button.currentImage == inactiveResetImage {
                button.setImage(activeResetImage, for: .normal)
            } else if button.currentImage == inactiveDeleteImage {
                button.setImage(activeDeleteImage, for: .normal)
            }
        } else {
            if button.currentImage == activeResetImage {
                button.setImage(inactiveResetImage, for: .normal)
            } else if button.currentImage == activeDeleteImage {
                button.setImage(inactiveDeleteImage, for: .normal)
            }
        }
    }
}
