//
//  RepeatView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/24/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PeriodsView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        return stackView
    }()
    
    let selection = PublishSubject<PeriodViewModel>()
    let menuSelection = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func bind(items: [PeriodViewModel]) {
        items.forEach { (periodViewModel) in
            let periodView = PeriodView()
            periodView.bind(viewModel: periodViewModel)
            
            Observable.of(periodView.selection, periodView.menuSelection)
                .merge()
                .do(onNext: { self.selection.onNext(periodViewModel) })
                .subscribe()
                .disposed(by: disposeBag)
            
            periodView.menuSelection
                .bind(to: menuSelection)
                .disposed(by: disposeBag)
            
            stackView.addArrangedSubview(periodView)
        }
    }
}
