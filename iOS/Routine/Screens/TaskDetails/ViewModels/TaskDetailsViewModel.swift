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
        let menuSelection: Driver<Void>
    }

    struct Output {
        let dismissAction: Driver<Void>
        let doneButtonEnabled: Driver<Bool>
        let showPickerAction: Driver<Void>
    }

    let title: BehaviorRelay<String?>
    let resetTypeIndex: BehaviorRelay<Int>
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
        self.resetTypeIndex = BehaviorRelay(value: Int(task?.resetType.rawValue ?? 0))
        
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
            .withLatestFrom(Observable.combineLatest(
                selectedPeriodItem,
                title,
                resetTypeIndex
            ))
            .map { [weak self] (item, title, resetTypeIndex) in
                let resetType = Task.ResetType(rawValue: Int16(resetTypeIndex))
                self?.saveTask(withTitle: title,
                               period: item?.period,
                               periodCount: item?.periodCount.value,
                               resetType: resetType)
            }
            .asDriver(onErrorJustReturn: ())
        
        let doneButtonEnabled = Observable.combineLatest(title, selectedPeriodItem)
            .map { (title, period) in
                title?.isEmpty == false && period != nil
            }
            .asDriver(onErrorJustReturn: false)
        
        let showPickerAction = input.menuSelection
            .asObservable()
            .withLatestFrom(selectedPeriodItem)
            .map { [weak self] selectedPeriod in
                let selectedItem = String(selectedPeriod?.periodCount.value ?? 1)
                self?.period.selectedItem.accept(selectedItem)
            }
            .asDriver(onErrorJustReturn: ())
        
        input.selection
            .drive(onNext: { [weak self] period in
                self?.selectedPeriodItem.accept(period)
                self?.periodItems.forEach { (item) in
                    item.selected.accept(item.period == period.period)
                }
            })
            .disposed(by: disposeBag)
        
        period.doneButtonTapped
            .withLatestFrom(Observable.combineLatest(
                period.selectedItem,
                selectedPeriodItem
            ))
            .do(onNext: { (pickerItem, periodItem) in
                let count = Int(pickerItem) ?? 1
                periodItem?.periodCount.accept(count)
            })
            .subscribe()
            .disposed(by: disposeBag)

        return Output(dismissAction: dismissAction, doneButtonEnabled: doneButtonEnabled, showPickerAction: showPickerAction)
    }
    
    private func saveTask(withTitle title: String?, period: Period?, periodCount: Int?, resetType: Task.ResetType?) {

        guard let periodCount = periodCount,
            let period = period,
            let title = title,
            let resetType = resetType else {
                return
        }
                
        if let task = self.task {
            let task = Task(
                id: task.id,
                title: title,
                period: period,
                periodCount: periodCount,
                startDate: task.startDate,
                resetType: resetType
            )
            self.taskProvier.update(task: task)
        } else {
            let task = Task(
                id: UUID().uuidString,
                title: title,
                period: period,
                periodCount: periodCount,
                startDate: Date(),
                resetType: resetType
            )
            self.taskProvier.add(task: task)
        }
    }
}
