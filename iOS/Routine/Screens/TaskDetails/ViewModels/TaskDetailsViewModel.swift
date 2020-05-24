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
        
        var selectedPeriod = BehaviorRelay<PeriodViewModel?>(value: nil)
        self.items = Period.allCases.map { period in
            if let task = task, task.period == period {
                let viewModel = PeriodViewModel(task: task)
                selectedPeriod = BehaviorRelay(value: viewModel)
                return viewModel
            } else {
                return PeriodViewModel(period: period)
            }
        }
        self.selectedPeriod = selectedPeriod
    }
    
    func transform(input: Input) -> Output {
        let dismissAction = input.doneButtonAction.map(saveTask)
        
        let doneButtonEnabled = Observable.combineLatest(title, selectedPeriod)
            .map { (title, period) in
                title?.isEmpty == false && period != nil
            }
            .asDriver(onErrorJustReturn: false)
        
        input.selection
            .map { period in
                self.selectedPeriod.accept(period)
                self.items.forEach { (item) in
                    item.selected.accept(item.period == period.period)
                }
            }
            .drive()
            .disposed(by: disposeBag)

        return Output(dismissAction: dismissAction, doneButtonEnabled: doneButtonEnabled)
    }
    
    private func saveTask() {
        guard let periodViewModel = selectedPeriod.value,
            let periodCount = Int(periodViewModel.periodCount.value.nilIfEmpty ?? "1"),
            let title = self.title.value else { return }
        
        let period = periodViewModel.period
                
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
