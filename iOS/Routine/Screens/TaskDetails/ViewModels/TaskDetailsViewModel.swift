//
//  TaskDetailsViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class TaskDetailsViewModel {
    
    struct Input {
        let doneButtonAction: Driver<Void>
        let selection: Driver<PeriodViewModel>
    }

    struct Output {
        let dismissAction: Driver<Void>
        let doneButtonEnabled: Driver<Bool>
    }

    let title: BehaviorRelay<String?>
    let selectedPeriod: BehaviorRelay<PeriodViewModel?>
    let items: [PeriodViewModel]
    
    private let task: Task?
    private let disposeBag = DisposeBag()

    private lazy var taskProvier: TaskProvider = {
        let container = CoreDataManager.shared.persistentContainer
        let provider = TaskProvider(persistentContainer: container)
        return provider
    }()
    
    init(task: Task? = nil) {
        self.task = task
        self.title = BehaviorRelay(value: task?.title)
        
        var selectedPeriod: PeriodViewModel?
        self.items = Period.allCases.map { period in
            if let task = task, task.period == period {
                let viewModel = PeriodViewModel(task: task)
                selectedPeriod = viewModel
                return viewModel
            } else {
                return PeriodViewModel(period: period)
            }
        }
        self.selectedPeriod = BehaviorRelay(value: selectedPeriod)
    }
    
    func transform(input: Input) -> Output {
        let dismissAction = input.doneButtonAction.asObservable()
            .withLatestFrom(Observable.combineLatest(selectedPeriod, title))
            .map { (period, title) in
                let periodCount = Int(period?.periodCount.value.nilIfEmpty ?? "1")
                return (title, period?.period, periodCount)
            }
            .map(saveTask)
            .asDriver(onErrorJustReturn: ())
        
        let doneButtonEnabled = Observable.combineLatest(title, selectedPeriod)
            .map { (title, period) in
                title?.isEmpty == false && period != nil
            }
            .asDriver(onErrorJustReturn: false)
        
        input.selection
            .do(onNext: { period in
                self.selectedPeriod.accept(period)
                self.items.forEach { (item) in
                    item.selected.accept(item.period == period.period)
                }
            })
            .drive()
            .disposed(by: disposeBag)

        return Output(dismissAction: dismissAction, doneButtonEnabled: doneButtonEnabled)
    }
    
    private func saveTask(withTitle title: String?, period: Period?, periodCount: Int?) {
        guard let periodCount = periodCount, let period = period, let title = title else {
            return
        }
                        
        if let task = self.task {
            let task = Task(
                id: task.id,
                title: title,
                period: period,
                periodCount: periodCount,
                startDate: task.startDate
            )
            self.taskProvier.update(task: task)
        } else {
            let task = Task(
                id: UUID().uuidString,
                title: title,
                period: period,
                periodCount: periodCount
            )
            self.taskProvier.add(task: task)
        }
    }
}
