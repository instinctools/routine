import UIKit
import RxSwift
import RxBiBinding
import RoutineSharedKmp

final class PeriodView2: UIView {

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
        button.setImage(#imageLiteral(resourceName: "menu-black-18dp.pdf"), for: .normal)
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
    
    let period: PeriodUnit

    let selection = PublishSubject<Void>()
    let countChooser = PublishSubject<Int>()
    private(set) var isSelected: Bool
    
    private let disposeBag = DisposeBag()

    init(period: PeriodUnit) {
        self.period = period
        self.isSelected = false
        super.init(frame: .zero)
        layer.cornerRadius = 12
        setSelected(isSelected)
        setupLayout()
        bindPeriod()
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
    
    private func bindPeriod() {
        titleView.text = period.title()
        
        countSelectionView.rx.tap
            .do(onNext: {
                if !self.isSelected {
                    self.selection.onNext(())
                }
                self.countChooser.onNext(0)
            })
            .subscribe()
            .disposed(by: disposeBag)
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
    
    func adjustSelection(selectedUnit: PeriodUnit, count: Int) {
        if selectedUnit == period {
            setSelected(true)
            titleView.text = period.title(count: count)
        } else {
            setSelected(false)
            titleView.text = period.title()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        selection.onNext(())
    }
}