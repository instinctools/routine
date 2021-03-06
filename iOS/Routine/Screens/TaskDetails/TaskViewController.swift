//
//  TaskViewController.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxBiBinding

final class TaskViewController: UIViewController {
    
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
    
    private lazy var textView: PlaceholderTextView = {
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
    private lazy var repeatPeriodsView = PeriodsView()
    private lazy var periodPickerViewController = PeriodPickerViewController(
        viewModel: viewModel.period
    )
        
    private let viewModel: TaskDetailsViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: TaskDetailsViewModel) {
        self.viewModel = viewModel
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
        contentView.addArrangedSubview(textView)
        contentView.addArrangedSubview(resetTypeSegmentControl)
        
        let dividerView = LabelledDivider(label: "Repeat every").padding(.bottom, 8).uiView
        contentView.addArrangedSubview(dividerView)
        
        contentView.addArrangedSubview(repeatPeriodsView)
        
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
        
        let input = TaskDetailsViewModel.Input(
            doneButtonAction: doneButton.rx.tap.asDriver(),
            selection: repeatPeriodsView.selection.asDriver(onErrorDriveWith: .never()),
            menuSelection: repeatPeriodsView.menuSelection.asDriver(onErrorJustReturn: ())
        )
        let output = viewModel.transform(input: input)
        
        output.doneButtonEnabled
            .drive(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.dismissAction
            .drive(onNext: dismiss)
            .disposed(by: disposeBag)
        
        output.showPickerAction
            .do(onNext: showPeriodPicker)
            .drive()
            .disposed(by: disposeBag)
        
        
        (resetTypeSegmentControl.rx.selectedSegmentIndex <-> viewModel.resetTypeIndex)
            .disposed(by: disposeBag)

        (textView.rx.title <-> viewModel.title)
            .disposed(by: disposeBag)
        
        repeatPeriodsView.bind(items: viewModel.periodItems)        
    }
    
    private func keyboardWillShow(notification: Notification) {
        let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboardSize = value?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height - view.safeAreaInsets.bottom + 8
        }
    }

    private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    private func showPeriodPicker() {
        present(periodPickerViewController, animated: true)
    }
    
    private func dismiss() {
        dismiss(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
