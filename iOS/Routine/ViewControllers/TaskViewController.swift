//
//  TaskViewController.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI
import SnapKit

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
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 30, weight: .medium)
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
        textView.delegate = self
        textView.text = placeholder
        textView.textColor = .lightGray
        return textView
    }()
    
    private lazy var doneButton = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(didTapDoneButton)
    )
    
    private lazy var repeatView: UIView = UIHostingController(
        rootView: RepeatPeriodsView(selectedPeriod: task?.period, onSelect: onSelectPeriod)
    ).view

    private let placeholder = "Type recurring task name..."
    
    private let task: Task?
    private var selectedPeriod: Period?
    private let onTask: (Task) -> Void
    
    init(task: Task? = nil, onTask: @escaping (Task) -> Void) {
        self.task = task
        self.onTask = onTask
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update(withTitle: textView.text)
    }
    
    private func setupViews() {
        if let title = task?.title, !title.isEmpty {
            textView.text = title
            textView.textColor = .label
            selectedPeriod = task?.period
        }
        
        view.backgroundColor = .systemBackground
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancelButton)
        )
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setLeftBarButton(cancelButton, animated: false)
        navigationItem.setRightBarButton(doneButton, animated: false)
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        guard let period = selectedPeriod else { return }
        let task = Task(
            title: textView.text,
            period: period
        )
        onTask(task)
        dismiss(animated: true)
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
    
    private func update(withTitle title: String) {
        doneButton.isEnabled = !title.isEmpty && title != placeholder && selectedPeriod != nil
    }
    
    private func onSelectPeriod(_ period: Period) {
        selectedPeriod = period
        update(withTitle: textView.text)
    }
}

extension TaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .label
        }
        update(withTitle: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholder
            textView.textColor = .lightGray
        }
        update(withTitle: textView.text)
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let textLimit = 50
        if newText.count > textLimit { return false }
        
        update(withTitle: newText)
        
        return true
    }
}


