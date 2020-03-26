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

class TaskListViewController: UITableViewController {
    
    private var tasks: [Task] = [Task.mock, Task.mock2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Routine"
        tableView.separatorStyle = .none
        tableView.register(TableViewCell.self,
                           forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationController?.navigationBar.tintColor = .label
    }
    
    @objc private func didTapAddButton() {
        let rootViewController = TaskViewController(onTask: addTask)
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
}

private extension TaskListViewController {
    private func addTask(_ task: Task) {
        tasks.append(task)
        tableView.reloadData()
    }
    
    private func updateTask(_ task: Task, at index: Int) {
        tasks[index] = task
        tableView.reloadData()
    }
    
    private func removeTask(at indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
    }
}

extension TaskListViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return tasks.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCell.reuseIdentifier,
            for: indexPath
        )
        let rootView = TaskRowView(task: tasks[indexPath.row])
        let view: UIView = UIHostingController(rootView: rootView).view
        view.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.contentView.addSubview(view)

        view.snp.makeConstraints { (make) in
            make.leading.equalTo(cell.contentView.layoutMarginsGuide.snp.leading)
            make.trailing.equalTo(cell.contentView.layoutMarginsGuide.snp.trailing)
            make.top.equalTo(cell.contentView.layoutMarginsGuide.snp.top)
            make.bottom.equalTo(cell.contentView.layoutMarginsGuide.snp.bottom)
        }
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let task = tasks[indexPath.row]
        let rootViewController = TaskViewController(task: task) { (updatedTask) in
            self.updateTask(updatedTask, at: indexPath.row)
        }
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "") {  (_, _, completion) in
            completion(true)
        }
        action.backgroundColor = .systemBackground
        action.image = UIImage(named: "Reset")
        let swipeActions = UISwipeActionsConfiguration(actions: [action])

        return swipeActions
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "") {  (_, _, completion) in
            self.removeTask(at: indexPath)
            completion(true)
        }

        action.backgroundColor = .systemBackground
        action.image = UIImage(named: "Reset")
        let swipeActions = UISwipeActionsConfiguration(actions: [action])

        return swipeActions
    }
}
