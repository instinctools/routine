//
//  TaskListViewController.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa
import SwipeCellKit
import DifferenceKit

extension Int: Differentiable { }
typealias TasksTableSection = ArraySection<Int, TaskViewModel>

final class TaskListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(TaskTableViewCell.self,
                           forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add)
    
    private lazy var dataSource = makeDataSource()
        
    private let resetTaskSubject = PublishSubject<TaskViewModel>()
    private let deleteTaskSubject = PublishSubject<TaskViewModel>()
    
    private let viewModel: TaskListViewModel
    private let disposeBag = DisposeBag()
    
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
        setupLayout()
        bindViewModel()
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupView() {
        navigationItem.title = "Routine"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationController?.navigationBar.tintColor = .label
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showTaskDetailsView(task: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = TaskListViewModel.Input(
            viewWillAppearDriver: rx.viewWillAppear.asDriver(),
            didTapCellDriver: tableView.rx.modelSelected(TaskViewModel.self).asDriver(),
            didResetTaskDriver: resetTaskSubject.asObservable(),
            didDeleteTaskDriver: deleteTaskSubject.asObservable()
        )
            
        let output = viewModel.transform(input: input)
        
        output.tasks
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.taskSelected
            .drive(onNext: { [weak self] task in
                self?.showTaskDetailsView(task: task)
            })
            .disposed(by: disposeBag)
        
        output.placeholder
            .drive(tableView.rx.placeholderView)
            .disposed(by: disposeBag)
    }
    
    private func showTaskDetailsView(task: Task?) {
        let viewModel = TaskDetailsViewModel(task: task)
        let rootViewController = TaskViewController(viewModel: viewModel)
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
    
    private func makeDataSource() -> RxDiffableDataSource<Int, TaskViewModel> {
        return RxDiffableDataSource<Int, TaskViewModel>(
            animationConfiguration: .init(
                insertAnimation: .right,
                reloadAnimation: .fade,
                deleteAnimation: .right
            ),
            configureCell: { (tableView, indexPath, item) in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TaskTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! TaskTableViewCell
                cell.bind(viewModel: item)
                cell.delegate = self
                return cell
            }
        )
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    
    private func hasHeader(section: Int) -> Bool {
        guard dataSource.sectionModels.count == 2 else { return false }
        return section == 1
            && !dataSource.sectionModels[0].elements.isEmpty
            && !dataSource.sectionModels[1].elements.isEmpty
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if hasHeader(section: section) {
            return VStack { Divider().background(Color.gray) }.padding().uiView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if hasHeader(section: section) {
            return 16
        }
        return 0
    }
}

// MARK: - SwipeTableViewCellDelegate
extension TaskListViewController: SwipeTableViewCellDelegate {
    
    private func setup(swipeAction: SwipeAction, image: UIImage?) {
        swipeAction.hidesWhenSelected = false
        swipeAction.image = image
        swipeAction.backgroundColor = .systemBackground
        swipeAction.highlightedBackgroundColor = .systemBackground
    }
    
    private func model(atIndexPath indexPath: IndexPath) -> TaskViewModel {
        return dataSource.sectionModels[indexPath.section].elements[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsOptionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        options.expansionDelegate = AlphaExpansion()
        options.backgroundColor = .systemBackground
        return options
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        switch orientation {
        case .left:
            let reseteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                self.resetTaskSubject.onNext(self.model(atIndexPath: indexPath))
            }
            setup(swipeAction: reseteAction, image: UIImage(named: "reset"))
            
            return [reseteAction]
        case .right:
            let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                var alertStyle = UIAlertController.Style.actionSheet
                var message: String?
                if UIDevice.current.userInterfaceIdiom == .pad {
                    alertStyle = UIAlertController.Style.alert
                    message = "Are you sure you want delete the task?"
                }
                let alert = UIAlertController(title: nil, message: message, preferredStyle: alertStyle)
                let cancelAcction = UIAlertAction(title: "Cancel", style: .cancel)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.deleteTaskSubject.onNext(self.model(atIndexPath: indexPath))
                })
                  
                alert.addAction(cancelAcction)
                alert.addAction(deleteAction)
                self.present(alert, animated: true)
            }
            setup(swipeAction: deleteAction, image: UIImage(named: "delete"))
            
            return [deleteAction]
        }
    }
}
