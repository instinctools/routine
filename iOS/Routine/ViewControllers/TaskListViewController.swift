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

class TaskListViewController: UITableViewController {
    
    private var viewModel = TaskListViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
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
        
        viewModel.objectWillChange
            .sink(receiveValue: tableView.reloadData)
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
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

extension TaskListViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.tasksCount
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCell.reuseIdentifier,
            for: indexPath
        )
        
        let task = viewModel.task(at: indexPath.row)
        let rowViewModel = TaskViewModel(task: task)
        let rootView = TaskRowView(viewModel: rowViewModel)
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
        let index = indexPath.row
        showTaskView(task: viewModel.task(at: index))
    }
    
    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "") {  (_, _, completion) in
            self.viewModel.resetTask(at: indexPath.row)
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
            self.viewModel.deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            completion(true)
        }

        action.backgroundColor = .systemBackground
        action.image = UIImage(named: "Reset")
        let swipeActions = UISwipeActionsConfiguration(actions: [action])

        return swipeActions
    }
}
