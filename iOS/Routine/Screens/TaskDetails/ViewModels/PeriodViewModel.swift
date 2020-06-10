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
    
    let periodTitle = BehaviorRelay<String>(value: "")
    let selected: BehaviorRelay<Bool>
    let periodCount = PublishSubject<String>()
    
    let period: Period
    private let disposeBag = DisposeBag()
    
    private init(period: Period, periodCount: Int, selected: Bool) {
        self.selected = BehaviorRelay(value: selected)
        self.period = period
        self.periodTitle.accept(title(periodCount: periodCount))
        
        bind()
    }
    
    convenience init(period: Period) {
        self.init(period: period, periodCount: 1, selected: false)
    }
    
    convenience init(task: Task) {
        self.init(period: task.period, periodCount: task.periodCount, selected: true)
    }
    
    private func title(periodCount: Int) -> String {
        let hasPeriodCount = periodCount > 1
        switch period {
        case .day:
            return hasPeriodCount ? "\(periodCount) Days" : "Day"
        case .week:
            return hasPeriodCount ? "\(periodCount) Weeks" : "Week"
        case .month:
            return hasPeriodCount ? "\(periodCount) Monthes" : "Month"
        case .year:
            return hasPeriodCount ? "\(periodCount) Years" : "Year"
        }
    }
    
    private func bind() {
        periodCount
            .map { Int($0) ?? 0 }
            .map(title(periodCount:))
            .bind(to: periodTitle)
            .disposed(by: disposeBag)
        
        selected
            .filter { !$0 }
            .map { _ in "" }
            .bind(to: periodCount)
            .disposed(by: disposeBag)
    }
}
