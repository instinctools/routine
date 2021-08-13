//
//  PeriodViewModel.swift
//  PeriodViewModel
//
//  Created by Vadim Koronchik on 5.08.21.
//

import SwiftUI

final class PeriodViewModel: ObservableObject {
    
    let period: Period
    @Published var periodCount: Int
    
    init(period: Period, periodCount: Int) {
        self.period = period
        self.periodCount = periodCount
    }
}
