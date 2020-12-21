import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RoutineShared

final class TodoDetailsViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 0
        return view
    }()
    
    private lazy var titleView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.textLimit = 40
        textView.placeholder = "Type recurring task name..."
        textView.font = .systemFont(ofSize: 30, weight: .medium)
        return textView
    }()
    
    private lazy var resetTypeSegmentControl = UISegmentedControl(
           items: ["Reset to period", "Reset to date"]
    )
    
    private lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done)
    private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel)
    private lazy var periodSelectionView = PeriodSelectionView()
    
    private let todo: Todo?
    private lazy var presenter: TodoDetailsPresenter = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return TodoDetailsPresenter(
            todoId: todo?.id as String?,
            getTaskByIdSideEffect: appDelegate.getTaskByIdSideEffect,
            saveTaskSideEffect: appDelegate.saveTaskSideEffect
        )
    }()
    private lazy var uiBinder = UiBinder<TodoDetailsPresenter.Action, TodoDetailsPresenter.State>()
    
    private let disposeBag = DisposeBag()
    
    init(todo: Todo?) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        setupLayout()
        setupViews()
        bindViewModel()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map(keyboardWillShow(notification:))
            .subscribe()
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map(keyboardWillHide(notification:))
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setLeftBarButton(cancelButton, animated: false)
        navigationItem.setRightBarButton(doneButton, animated: false)
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(titleView)
        contentView.addArrangedSubview(resetTypeSegmentControl)
        
        let dividerView = LabelledDivider(label: "Repeat every").padding(.bottom, 8).uiView
        contentView.addArrangedSubview(dividerView)
        
        contentView.addArrangedSubview(periodSelectionView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        cancelButton.rx.tap
            .subscribe(onNext: dismiss)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .do(onNext: {
                let action = TodoDetailsPresenter.ActionSaveTask()
                self.presenter.sendAction(action: action)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        periodSelectionView.selection
            .do(onNext: { period in
                let action = TodoDetailsPresenter.ActionChangePeriodUnit(periodUnit: period.unit)
                self.presenter.sendAction(action: action)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        periodSelectionView.countChooser
            .do(onNext: { count in
                self.showCountSelectionAlert(initialCount: count)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        resetTypeSegmentControl.addTarget(self, action: #selector(onStrategyChanged), for: .valueChanged)
                
//        let input = TaskDetailsViewModel.Input(
//            doneButtonAction: doneButton.rx.tap.asDriver(),
//            selection: repeatPeriodsView.selection.asDriver(onErrorDriveWith: .never())
//        )
//        let output = viewModel.transform(input: input)
//
//        output.doneButtonEnabled
//            .drive(doneButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//
//        (textView.rx.title <-> viewModel.title)
//            .disposed(by: disposeBag)
//
        uiBinder.bindTo(presenter: presenter, listener: { state, oldState in
            state.saved.consumeOneTimeEvent(consumer: { _ in
                self.dismiss()
            })
            
            let todo = state.todo
            self.titleView.textView.text = todo.title
            
            self.periodSelectionView.showPeriods(periods: state.periods)
            self.periodSelectionView.selectPeriod(unit: todo.periodUnit)
            
            if todo.periodStrategy == PeriodResetStrategy.fromnow {
                self.resetTypeSegmentControl.selectedSegmentIndex = 0
            } else {
                self.resetTypeSegmentControl.selectedSegmentIndex = 1
            }
        })
    }
    
    @objc func onStrategyChanged(target: UISegmentedControl) {
        if target == resetTypeSegmentControl {
            let selectedSegmentIndex = target.selectedSegmentIndex
            let newStrategy: PeriodResetStrategy
            if selectedSegmentIndex == 0 {
                newStrategy = .fromnow
            } else {
                newStrategy = .fromnextevent
            }
            let action = TodoDetailsPresenter.ActionChangePeriodStrategy(periodStrategy: newStrategy)
            presenter.sendAction(action: action)
        }
    }
    
    private func showCountSelectionAlert(initialCount: Int) {
        present(PeriodPickerViewController(initialCount: initialCount), animated: true)
    }
    
    private func keyboardWillShow(notification: Notification) {
        let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboardSize = value?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height - view.safeAreaInsets.bottom
        }
    }

    private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    private func dismiss() {
        dismiss(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

func weakify <T: AnyObject>(_ owner: T, _ f: @escaping (T) -> () -> Void) -> () -> Void {
    return { [weak owner] in
        return owner.map { f($0)() }
    }
}
