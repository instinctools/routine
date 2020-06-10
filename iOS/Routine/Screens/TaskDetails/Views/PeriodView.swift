//
//  PeriodView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import RxBiBinding

final class PeriodView: UIView {
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "menu2"), for: [.selected, .highlighted])
        return button
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [menuButton, UIView(), periodLabel]
        )
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()

    let selection = PublishSubject<Void>()
    let menuSelection = PublishSubject<Void>()
    private(set) var isSelected: Bool
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.isSelected = false
        super.init(frame: .zero)
        layer.cornerRadius = 12
        setSelected(isSelected)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
    }
    
    private func setSelected(_ selected: Bool) {
        isSelected = selected
        if isSelected {
            menuButton.setImage(UIImage(named: "menu"), for: .normal)
            periodLabel.textColor = .white
            backgroundColor = .gray
        } else {
            menuButton.setImage(UIImage(named: "menu3"), for: .normal)
            periodLabel.textColor = .gray
            backgroundColor = .secondarySystemBackground
        }
    }
    
    func bind(viewModel: PeriodViewModel) {
        viewModel.periodTitle
            .bind(to: periodLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.selected
            .map(setSelected)
            .subscribe()
            .disposed(by: disposeBag)
        
        menuButton.rx.tap.bind(to: menuSelection)
            .disposed(by: disposeBag)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        selection.onNext(())
    }
}

extension PeriodView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let newText = ((textField.text.orEmpty) as NSString).replacingCharacters(in: range, with: string)
        
        if newText == "0" {
            return false
        }
        
        let textLimit = 3
        if newText.count <= textLimit {
            return true
        }
        
        return false
    }
}
