import SwiftUI
import SwipeCellKit
import RoutineShared
import RxDataSources
import RxSwift

final class TodoListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var emptyView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var emptyTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0x4E, green: 0x4E, blue: 0x53)
        label.text = "Oh! It\'s still empty"
        return label
    }()
    private lazy var emptyMessage: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0x9A, green: 0x99, blue: 0xA2)
        label.text = "There are no routine tasks"
        return label
    }()
    private lazy var emptyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "No todos")
        return imageView
    }()

    private lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add)
    private lazy var menuButton = UIBarButtonItem(image: UIImage(named: "Side Menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuClicked))
    
    private lazy var dataSource = makeDataSource()

    private lazy var presenter: TodoListPresenter = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return TodoListPresenter(
            getTasksSideEffect: appDelegate.getTasksSideEffect,
            deleteTaskSideEffect: appDelegate.deleteTaskSideEffect,
            resetTaskSideEffect: appDelegate.resetTaskSideEffect,
            refreshTasksSideEffect: appDelegate.refreshTasksSideEffect
        )
    }()
    private lazy var uiBinder = UiBinder<TodoListPresenter.Action, TodoListPresenter.State>()
    
    private let todosSectionsSubject = PublishSubject<[TodosTableSection]>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindPresenter()
    }

    private func setupView() {
        navigationItem.title = "Routine"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationItem.setLeftBarButton(menuButton, animated: false)
        navigationController?.navigationBar.tintColor = .label

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(emptyView)
        
        emptyView.addArrangedSubview(emptyIcon)
        emptyView.addArrangedSubview(emptyTitle)
        emptyView.addArrangedSubview(emptyMessage)
        
        emptyView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        addButton.rx.tap
            .do(onNext: showTaskCreationView)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindPresenter() {
        uiBinder.bindTo(presenter: presenter, listener: { state, oldState in
            let itemsCount = state.expiredTodos.count + state.futureTodos.count
            print("state loaded, items \(itemsCount)")
            let sections = [
                TodosTableSection(section: 0, items: state.expiredTodos),
                TodosTableSection(section: 1, items: state.futureTodos)
            ]
            self.todosSectionsSubject.onNext(sections)
            
            self.tableView.isHidden = itemsCount == 0
            self.emptyView.isHidden = itemsCount != 0
        })
        
        todosSectionsSubject.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func showTodoDetailsView(item: TodoListUiModel?) {
        let rootViewController = TodoDetailsViewController(todo: item?.todo)
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }

    private func showTaskCreationView() {
        showTodoDetailsView(item: nil)
    }
    
    @objc private func menuClicked() {
    }

    private func makeDataSource() -> RxTableViewSectionedAnimatedDataSource<TodosTableSection> {
        return RxTableViewSectionedAnimatedDataSource<TodosTableSection>(
                animationConfiguration: .init(
                        insertAnimation: .none,
                        reloadAnimation: .none,
                        deleteAnimation: .none
                ),
                configureCell: { (dataSource, tableView, indexPath, item) in
                    let cell = tableView.dequeueReusableCell(
                            withIdentifier: TodoTableViewCell.reuseIdentifier,
                            for: indexPath
                    ) as! TodoTableViewCell
                    cell.bind(to: item, parent: self)
                    cell.delegate = self
                    return cell
                }
        )
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {

    private func hasHeader(section: Int) -> Bool {
        return section == 1
        && !dataSource.sectionModels[0].items.isEmpty
        && !dataSource.sectionModels[1].items.isEmpty
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if hasHeader(section: section) {
            return VStack {
                Divider().background(Color.gray)
            }.padding().uiView
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
extension TodoListViewController: SwipeTableViewCellDelegate {

    private func setup(swipeAction: SwipeAction, image: UIImage?) {
        swipeAction.hidesWhenSelected = false
        swipeAction.image = image
        swipeAction.backgroundColor = .systemBackground
        swipeAction.highlightedBackgroundColor = .systemBackground
    }

    private func model(atIndexPath indexPath: IndexPath) -> TodoListUiModel {
        return dataSource.sectionModels[indexPath.section].items[indexPath.row]
    }

    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        switch orientation {
        case .left:
            let reseteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                let todoId = self.model(atIndexPath: indexPath).todo.id
                let action = TodoListPresenter.ActionResetTask(taskId: todoId)
                self.presenter.sendAction(action: action)
            }
            setup(swipeAction: reseteAction, image: UIImage(named: "reset"))

            return [reseteAction]
        case .right:
            let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
//                let message = "Are you sure you want to delete the task?"
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

                alert.addAction(.init(title: "Cancel", style: .cancel))
                alert.addAction(.init(title: "Delete", style: .destructive, handler: { _ in
                    let todoId = self.model(atIndexPath: indexPath).todo.id
                    let action = TodoListPresenter.ActionDeleteTask(taskId: todoId)
                    self.presenter.sendAction(action: action)
                }))

                self.present(alert, animated: true)
            }
            setup(swipeAction: deleteAction, image: UIImage(named: "delete"))

            return [deleteAction]
        }
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
}

struct AlphaExpansion: SwipeExpanding {
    func animationTimingParameters(buttons: [UIButton], expanding: Bool) -> SwipeExpansionAnimationTimingParameters {
        return .default
    }
    
    func actionButton(_ button: UIButton, didChange expanding: Bool, otherActionButtons: [UIButton]) {
        UIView.animate(withDuration: 0.2) {
            button.alpha = expanding ? 0.7 : 1.0
        }
    }
}

struct TodosTableSection {
    var section: Int
    var items: [TodoListUiModel]
}

extension TodosTableSection: AnimatableSectionModelType {
    
    var identity: Int {
        return section
    }

    init(original: TodosTableSection, items: [TodoListUiModel]) {
        self = original
        self.items = items
    }
}

extension TodoListUiModel : IdentifiableType {
    public var identity: String {
        return String(todo.id)
    }
}
