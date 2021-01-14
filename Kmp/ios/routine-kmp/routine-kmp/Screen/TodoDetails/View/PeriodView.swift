import UIKit
import RxSwift
import RxBiBinding
import RoutineShared

final class PeriodView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()

    private let titleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .left
        label.text = "Every"
        return label
    }()
    
    private let countSelectionView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Period Selection"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleToFill
        return button
    }()

    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    var period: PeriodUnitUiModel

    let selection = PublishSubject<Void>()
    let countChooser = PublishSubject<Int>()
    private(set) var isSelected: Bool
    
    private let disposeBag = DisposeBag()

    init(period: PeriodUnitUiModel) {
        self.period = period
        self.isSelected = false
        super.init(frame: .zero)
        layer.cornerRadius = 12
        setSelected(isSelected)
        setupLayout()
        
        countSelectionView.rx.tap
            .do(onNext: {
                if !self.isSelected {
                    self.selection.onNext(())
                }
                self.countChooser.onNext(Int(self.period.count))
            })
            .subscribe()
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(stackView)
        
        countSelectionView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
        }
        
        stackView.addArrangedSubview(countSelectionView)
        stackView.setCustomSpacing(8.0, after: titleView)

        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.addArrangedSubview(spacerView)

        stackView.addArrangedSubview(titleView)
        stackView.setCustomSpacing(8.0, after: titleView)

        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(14)
            make.center.equalToSuperview()
        }
    }
    
    func bindPeriod(period: PeriodUnitUiModel) {
        self.period = period
        titleView.text = period.unit.title(count: Int(period.count))
    }

    private func setSelected(_ selected: Bool) {
        isSelected = selected
        if isSelected {
            titleView.textColor = .white
            circleView.backgroundColor = .white
            backgroundColor = .gray
        } else {
            titleView.textColor = .gray
            circleView.backgroundColor = .gray
            backgroundColor = .secondarySystemBackground
        }
    }
    
    func adjustSelection(selectedUnit: PeriodUnit?) {
        setSelected(selectedUnit == period)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        selection.onNext(())
    }
}
