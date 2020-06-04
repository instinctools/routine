//
//  PeriodViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/17/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import RxSwift
import RxCocoa

final class PeriodViewModel {
    
    let periodTitle: BehaviorRelay<String>
    let selected: BehaviorRelay<Bool>
    let periodCount = PublishSubject<String>()
    
    let period: Period
    private let disposeBag = DisposeBag()
    
    private init(period: Period, periodCount: Int, selected: Bool) {
        self.periodTitle = BehaviorRelay(value: period.title(periodCount: periodCount))
        self.selected = BehaviorRelay(value: selected)
        self.period = period
        
        bind()
    }
    
    convenience init(period: Period) {
        self.init(period: period, periodCount: 1, selected: false)
    }
    
    convenience init(task: Task) {
        self.init(period: task.period, periodCount: task.periodCount, selected: true)
    }
    
    private func bind() {
        periodCount
            .map { Int($0) ?? 0 }
            .map(period.title)
            .bind(to: periodTitle)
            .disposed(by: disposeBag)
        
        selected
            .filter { !$0 }
            .map { _ in "" }
            .bind(to: periodCount)
            .disposed(by: disposeBag)
    }
}
