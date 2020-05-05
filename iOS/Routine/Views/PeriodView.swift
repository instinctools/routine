//
//  PeriodView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI

typealias EmptyAction = () -> Void

struct PeriodViewModel {
    let period: Period
    var periodCount: Int?
    
    var title: String {
        return period.title(periodCount: periodCount)
    }
}

final class PeriodView: UIView {
    
    private let everyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .left
        label.text = "Every"
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var periodCountTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 22, weight: .semibold)
        textField.textColor = .white
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.tintColor = .white
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()

    private(set) var isSelected: Bool
    
    private var viewModel: PeriodViewModel!
    var didSelect: ((_ period: Period, _ count: String) -> Void)?
    
    init() {
        self.isSelected = false
        super.init(frame: .zero)
        setSelected(isSelected)
        
        layer.cornerRadius = 12
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(everyLabel)
        stackView.setCustomSpacing(8.0, after: everyLabel)
        stackView.addArrangedSubview(titleLabel)
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.addArrangedSubview(spacerView)
        
        let circleSuperview = UIView()
        circleSuperview.addSubview(circleView)
        circleView.snp.makeConstraints { (make) in
            make.width.equalTo(10)
            make.height.equalTo(circleView.snp.width)
            make.top.greaterThanOrEqualToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        circleSuperview.snp.makeConstraints { (make) in
            make.width.equalTo(20)
        }
        stackView.addArrangedSubview(circleSuperview)
        
        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
            make.center.equalToSuperview()
        }
    }
    
    private func setSelected(_ selected: Bool, firstResponder: Bool = true) {
        isSelected = selected
        if isSelected {
            stackView.insertArrangedSubview(periodCountTextField, at: 1)
            stackView.setCustomSpacing(4.0, after: periodCountTextField)
            if firstResponder {
                periodCountTextField.becomeFirstResponder()
            }
            everyLabel.textColor = .white
            titleLabel.textColor = .white
            circleView.backgroundColor = .white
            backgroundColor = .gray
        } else {
            periodCountTextField.text = ""
            periodCountTextField.removeFromSuperview()
            everyLabel.textColor = .gray
            titleLabel.textColor = .gray
            circleView.backgroundColor = .gray
            backgroundColor = .secondarySystemBackground
        }
    }
    
    func select() {
        setSelected(true)
    }
    
    func deselect() {
        setSelected(false)
    }
    
    func setup(with viewModel: PeriodViewModel, isSelected: Bool) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        if let count = viewModel.periodCount {
            periodCountTextField.text = String(count)
        }
        setSelected(isSelected, firstResponder: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        select()
        didSelect?(viewModel.period, periodCountTextField.text.orEmpty)
    }
}

extension PeriodView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let newText = ((textField.text.orEmpty) as NSString).replacingCharacters(in: range, with: string)
        let textLimit = 3
        if newText.count <= textLimit {
            didSelect?(viewModel.period, newText)
            viewModel.periodCount = Int(newText)
            titleLabel.text = viewModel.title
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.removeFromSuperview()
        }
    }
}
