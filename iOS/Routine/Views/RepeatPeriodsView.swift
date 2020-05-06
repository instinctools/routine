//
//  RepeatView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/24/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI
import UIKit
import SnapKit

final class PeriodsView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        return stackView
    }()
    
    private var periodViews: [PeriodView] = []
    
    var didSelect: ((_ period: Period, _ count: String) -> Void)?
    
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
    
    func setup(with periods: [Period], selectedPeriod: Period?, count: String) {
        periodViews.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        periods.forEach { (period) in
            let periodView = PeriodView()
            periodView.didSelect = { (period, count) in
                self.didSelect?(period, count)
                self.didTapPeriodView(periodView)
            }
            let count = Int(count) ?? 1
            if period == selectedPeriod {
                periodView.setup(with: PeriodViewModel(period: period, periodCount: count), isSelected: true)
            } else {
                periodView.setup(with: PeriodViewModel(period: period, periodCount: count), isSelected: false)
            }
            
            periodViews.append(periodView)
            stackView.addArrangedSubview(periodView)
        }
    }
    
    private func didTapPeriodView(_ view: PeriodView) {
        for periodView in periodViews where periodView != view && periodView.isSelected {
            periodView.deselect()
        }
    }
}
