//
//  PeriodPickerViewModel.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/4/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class PeriodPickerViewModel {
    
    let items: Observable<[String]>
    let selectedItem: BehaviorRelay<String>
    let doneButtonTapped = PublishSubject<Void>()
    
    init(selectedItem: String) {
        let value = (1...60).map(String.init)
        self.items = .just(value)
        self.selectedItem = BehaviorRelay(value: selectedItem)
    }
}
