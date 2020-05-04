//
//  TaskViewController.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Combine
import SnapKit

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
    
    private lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done)
    private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel)
    
    private lazy var dividerView = LabelledDivider(label: "Repeat").padding(.bottom, 8).uiView
    
    private lazy var repeatPeriodsView = PeriodsView()
        
    private let viewModel: TaskDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []
    
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
        contentView.addArrangedSubview(dividerView)
        contentView.addArrangedSubview(repeatPeriodsView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.centerX.equalTo(view.snp.centerX)
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func bindViewModel() {
        cancelButton.tap
            .sink(receiveValue: weakify(self, TaskViewController.dismiss))
            .store(in: &cancellables)
        
        doneButton.tap
            .map(viewModel.saveTask)
            .sink(receiveValue: weakify(self, TaskViewController.dismiss))
            .store(in: &cancellables)
        
        viewModel.$doneButtonIsEnabled
            .assign(to: \.isEnabled, on: doneButton)
            .store(in: &cancellables)
                
        textView.textPublisher
            .sink(receiveValue: viewModel.setTitle)
            .store(in: &cancellables)
        
        viewModel.$title
            .assign(to: \.text, on: textView)
            .store(in: &cancellables)
        
        repeatPeriodsView.didSelect = { (period, count) in
            self.viewModel.setPeriod(period, count: count)
        }
        
        repeatPeriodsView.setup(
            with: Period.allCases.map { $0 },
            selectedPeriod: viewModel.selectedPeriod,
            count: viewModel.selectedPeriodCount
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboardSize = value?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height - view.safeAreaInsets.bottom
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
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
