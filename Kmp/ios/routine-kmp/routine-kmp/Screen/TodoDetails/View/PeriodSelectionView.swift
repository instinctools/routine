import UIKit
import RxSwift
import RoutineShared

final class PeriodSelectionView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        return stackView
    }()
    
    let selection = PublishSubject<PeriodUnitUiModel>()
    let countChooser = PublishSubject<Int>()
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
    
    func showPeriods(periods: [PeriodUnitUiModel]) {
        for period in periods {
            var periodView: PeriodView? = nil
            for child in stackView.subviews {
                if let castedChild = child as? PeriodView {
                    if(castedChild.period.unit == period.unit) {
                        periodView = castedChild
                    }
                }
            }
            
            if periodView == nil {
                periodView = PeriodView(period: period)
                
                periodView!.selection.map {
                    self.selection.onNext(periodView!.period)
                }.subscribe().disposed(by: disposeBag)
                
                periodView!.countChooser.map { count in
                    self.countChooser.onNext(count)
                }.subscribe().disposed(by: disposeBag)
                
                stackView.addArrangedSubview(periodView!)
            }
            
            periodView?.bindPeriod(period: period)
        }
    }
    
    func selectPeriod(unit: PeriodUnit?) {
        for view in stackView.subviews {
            let periodView = view as? PeriodView
            periodView?.adjustSelection(selectedUnit: unit)
        }
    }
}
