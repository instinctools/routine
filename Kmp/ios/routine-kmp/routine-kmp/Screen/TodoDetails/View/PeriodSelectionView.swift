import UIKit
import RxSwift
import RoutineSharedKmp

final class PeriodSelectionView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        return stackView
    }()
    
    let selection = PublishSubject<PeriodUnit>()
    private let disposeBag = DisposeBag()

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
    
    func showPeriods(periods: [PeriodUnit]) {
        for period in periods {
            let periodView = PeriodView2(period: period)
            
            periodView.selection.map {
                self.selection.onNext(period)
            }.subscribe().disposed(by: disposeBag)
            
            stackView.addArrangedSubview(periodView)
        }
    }
    
    func selectPeriod(unit: PeriodUnit, count: Int) {
        for view in stackView.subviews {
            let periodView = view as? PeriodView2
            periodView?.adjustSelection(selectedUnit: unit, count: count)
        }
    }
}
