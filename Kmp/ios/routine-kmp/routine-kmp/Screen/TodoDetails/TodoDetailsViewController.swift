import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RoutineSharedKmp

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
    
    private lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done)
    private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel)
    private lazy var periodSelectionView = PeriodSelectionView()
    
    private let todo: Todo?
    private lazy var presenter: TodoDetailsPresenter = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let presenter = TodoDetailsPresenter(todoId: todo?.id as? KotlinLong, todoStore: appDelegate.todoStore)
        return presenter
    }()
    private lazy var uiBinder = UiBinder<TodoDetailsPresenter.State, TodoDetailsPresenter.Event>()
    
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
                let event = TodoDetailsPresenter.EventSave()
                self.presenter.events.offer(element: event)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        periodSelectionView.selection
            .do(onNext: { period in
                let event = TodoDetailsPresenter.EventChangePeriodUnit(periodUnit: period)
                self.presenter.events.offer(element: event)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        periodSelectionView.showPeriods(periods: PeriodUnit.Companion().allPeriods())
        
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
            if(state.saved) {
                self.dismiss()
                return
            }
            
            let todo = state.todo
            self.titleView.textView.text = todo.title
            self.periodSelectionView.selectPeriod(unit: todo.periodUnit, count: Int(todo.periodValue))
        })
        
        presenter.start()
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
