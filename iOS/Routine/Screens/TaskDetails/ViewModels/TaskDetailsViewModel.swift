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
    let selectedPeriodItem: BehaviorRelay<PeriodViewModel?>
    let periodItems: [PeriodViewModel]
    let period: PeriodPickerViewModel
    
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
        self.periodItems = Period.allCases.map { period in
            if let task = task, task.period == period {
                let viewModel = PeriodViewModel(task: task)
                selectedPeriod = viewModel
                return viewModel
            } else {
                return PeriodViewModel(period: period)
            }
        }
        self.selectedPeriodItem = BehaviorRelay(value: selectedPeriod)
        self.period = PeriodPickerViewModel(selectedItem: String(task?.periodCount ?? 1))
    }
    
    func transform(input: Input) -> Output {
        let dismissAction = input.doneButtonAction.asObservable()
            .withLatestFrom(
                Observable.combineLatest(selectedPeriodItem, period.selectedItem, title)
            )
            .map { (item, period, title) in
                return (title, item?.period, Int(period))
            }
            .map(saveTask)
            .asDriver(onErrorJustReturn: ())
        
        let doneButtonEnabled = Observable.combineLatest(title, selectedPeriodItem)
            .map { (title, period) in
                title?.isEmpty == false && period != nil
            }
            .asDriver(onErrorJustReturn: false)
        
        input.selection
            .do(onNext: { period in
                self.selectedPeriodItem.accept(period)
                self.periodItems.forEach { (item) in
                    item.selected.accept(item.period == period.period)
                }
            })
            .drive()
            .disposed(by: disposeBag)
        
        period.doneButtonTapped
            .withLatestFrom(period.selectedItem)
            .do(onNext: { (item) in
                self.selectedPeriodItem.value?.periodCount.onNext(item)
            })
            .subscribe()
            .disposed(by: disposeBag)

        return Output(dismissAction: dismissAction, doneButtonEnabled: doneButtonEnabled)
    }
    
    private func saveTask(withTitle title: String?, period: Period?, periodCount: Int?) {
        guard let periodCount = periodCount, let period = period, let title = title else {
            return
        }
        
        let calendar = Calendar.current
        
        if let task = self.task {
            let startDate = calendar.date(
                byAdding: task.period.calendarComponent,
                value: -task.periodCount,
                to: task.finishDate
            ).orToday
            let finishDate = calendar.date(
                byAdding: period.calendarComponent,
                value: periodCount,
                to: startDate
            ).orToday
            let task = Task(
                id: task.id,
                title: title,
                period: period,
                periodCount: periodCount,
                finishDate: finishDate
            )
            self.taskProvier.update(task: task)
        } else {
            let finishDate = calendar.date(
                byAdding: period.calendarComponent,
                value: periodCount,
                to: Date()
            ).orToday
            let task = Task(
                id: UUID().uuidString,
                title: title,
                period: period,
                periodCount: periodCount,
                finishDate: finishDate
            )
            self.taskProvier.add(task: task)
        }
    }
}
