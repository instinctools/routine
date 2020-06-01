import UIKit
import RxSwift
import RxCocoa

final class PeriodsView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        return stackView
    }()
    
    let selection = PublishSubject<PeriodViewModel>()
    
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

    func bind(items: [PeriodViewModel]) {
        items.forEach { (periodViewModel) in
            let periodView = PeriodView()
            periodView.bind(viewModel: periodViewModel)
            
            periodView.selection.map {
//                self.select(view: periodView)
                self.selection.onNext(periodViewModel)
            }.subscribe().disposed(by: disposeBag)
            
            periodViews.append(periodView)
            stackView.addArrangedSubview(periodView)
        }
    }
    
//    private func select(view: PeriodView) {
//        for periodView in periodViews {
//            periodView.setSelected(periodView == view)
//        }
//    }
}
