import UIKit
import RxSwift
import RxCocoa
import RoutineSharedKmp

final class PeriodsView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        return stackView
    }()
    
    let selection = PublishSubject<PeriodUiModel>()
    
    private var periodViews: [PeriodView] = []
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

    func bind(items: [PeriodUiModel], selected: PeriodUnit, count: Int) {
        items.forEach { (periodUiModel) in
            let periodView = PeriodView()
            periodView.bind(uiModel: periodUiModel)
            
            periodView.selection.map {
                self.selection.onNext(periodUiModel)
            }.subscribe().disposed(by: disposeBag)
            
            periodViews.append(periodView)
            stackView.addArrangedSubview(periodView)
        }
    }
}
