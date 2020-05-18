//
//  TaskTableViewCell.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwipeCellKit

final class TaskTableViewCell: SwipeTableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var timeLeftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var containerView = UIView()
    
    private lazy var stackView: UIStackView = {
        let horizontalStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                periodLabel,
                UIView(),
                timeLeftLabel
            ])
            stackView.axis = .horizontal
            return stackView
        }()
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            horizontalStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        containerView.layer.cornerRadius = 12
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)

        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind(viewModel: TaskViewModel) {
        viewModel.color.bind(to: containerView.rx.backgroundColor).disposed(by: disposeBag)
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.period.bind(to: periodLabel.rx.text).disposed(by: disposeBag)
        viewModel.timeLeft.bind(to: timeLeftLabel.rx.text).disposed(by: disposeBag)
    }
}
