//
//  TaskViewController.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import SnapKit

extension View {
    var uiView: UIView {
        return UIHostingController(rootView: self).view
    }
}

extension UIBarButtonItem {
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }
}

class TaskViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
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
    
    private lazy var repeatView = RepeatPeriodsView(
        selectedPeriod: viewModel.selectedPeriod, onSelect: viewModel.setPeriod
    ).uiView
        
    @ObservedObject var viewModel: TaskDetailsViewModel
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
        setupLayout()
        setupViews()
        bindViewModel()
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
        contentView.addArrangedSubview(repeatView)
        
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
        let output = viewModel.transform(input: .init(
            title: textView.textPublisher,
            doneButtonDidTap: doneButton.tap.eraseToAnyPublisher())
        )
        
        cancelButton.tap
            .sink(receiveValue: weakify(self, TaskViewController.dismiss))
            .store(in: &cancellables)

        output.doneButtonIsEnabled
            .assign(to: \.isEnabled, on: doneButton)
            .store(in: &cancellables)
        
        output.title
            .assign(to: \.text, on: textView)
            .store(in: &cancellables)
        
        output.onClose
            .sink(receiveValue: weakify(self, TaskViewController.dismiss))
            .store(in: &cancellables)
    }
    
    private func dismiss() {
        dismiss(animated: true)
    }
}

func weakify <T: AnyObject>(_ owner: T, _ f: @escaping (T) -> () -> Void) -> () -> Void {
    return { [weak owner] in
        return owner.map { f($0)() }
    }
}
