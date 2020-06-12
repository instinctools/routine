import UIKit
import SwiftUI
import RxCocoa
import RxSwift
import RxBiBinding
import RoutineSharedKmp

final class PeriodPickerViewController: BottomCardViewController {
    
    private let pickerView = UIPickerView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .gray
        label.text = "Choose period"
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let topView = UIView()
        let topStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            UIView(),
            doneButton
        ])
        topStackView.axis = .horizontal
        topView.addSubview(topStackView)
        
        topStackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(6)
        }
        
        let stackView = UIStackView(arrangedSubviews: [
            topView,
            Divider().background(Color.gray).uiView,
            pickerView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 6.0
        
        return stackView
    }()
    
    private let disposeBag = DisposeBag()

    private let initialCount: Int
    private var selectedCount: Int = 0

    init(initialCount: Int) {
        self.initialCount = initialCount
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        doneButton.rx.tap
            .do(onNext: hide)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        view.addSubview(contentStackView)

        contentStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        Observable.just(PeriodUnit.Companion().possiblePeriodValuesZeroPadded).bind(to: pickerView.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: disposeBag)

        pickerView.rx.modelSelected(String.self)
            .do(onNext: { newCount in
                print(newCount)
            })
            .subscribe().disposed(by: disposeBag)
        
        doneButton.rx.tap
            .do(onNext: {
                //do smth
            })
            .subscribe().disposed(by: disposeBag)
        
        // select current item
        let row = (initialCount) - 1
        let component = 0
        if self.pickerView.selectedRow(inComponent: component) != row {
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
        }
    }

    private func hide() {
        self.dismiss(animated: true)
    }
}
