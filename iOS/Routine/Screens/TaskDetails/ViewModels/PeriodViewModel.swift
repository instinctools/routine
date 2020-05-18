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
    
    let title: BehaviorRelay<String>
    let selected: BehaviorRelay<Bool>
    let periodCount: BehaviorRelay<String?>
    let periodCountHidden: BehaviorRelay<Bool>
    let isFirstResponder = PublishSubject<Bool>()
    
    let period: Period
    private let disposeBag = DisposeBag()
    
    private init(period: Period, periodCount: Int, selected: Bool) {
        self.title = BehaviorRelay(value: period.title(periodCount: periodCount))
        self.selected = BehaviorRelay(value: selected)
        self.period = period
        self.periodCount = BehaviorRelay(value: periodCount > 1 ? String(periodCount) : nil)
        self.periodCountHidden = BehaviorRelay(value: true)
        
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
            .map { Int($0.orEmpty) }
            .map(period.title)
            .bind(to: title)
            .disposed(by: disposeBag)
        
        isFirstResponder
            .filter { !$0 }
            .withLatestFrom(periodCount)
            .map { periodCount in
                if let count = Int(periodCount.orEmpty), count > 1 {
                    return String(count)
                }
                return ""
            }
            .bind(to: periodCount)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(selected, isFirstResponder, periodCount)
            .map { (selected, isFirstResponder, periodCount) in
                return !((selected && isFirstResponder) || periodCount?.isEmpty == false)
            }
            .bind(to: periodCountHidden)
            .disposed(by: disposeBag)
        
        selected
            .filter { !$0 }
            .map { _ in "" }
            .bind(to: periodCount)
            .disposed(by: disposeBag)
    }
}
