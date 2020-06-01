import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class PeriodView: UIView {
    
    private let everyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .left
        label.text = "Every"
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var periodCountTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "1",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.font = .systemFont(ofSize: 22, weight: .semibold)
        textField.textColor = .white
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.tintColor = .white
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()

    let selection = PublishSubject<Void>()
    private(set) var isSelected: Bool
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.isSelected = false
        super.init(frame: .zero)
        layer.cornerRadius = 12
        setSelected(isSelected)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(everyLabel)
        stackView.setCustomSpacing(8.0, after: everyLabel)
        
        stackView.addArrangedSubview(periodCountTextField)
        stackView.setCustomSpacing(4.0, after: periodCountTextField)
        
        stackView.addArrangedSubview(titleLabel)
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.addArrangedSubview(spacerView)
        
        let circleSuperview = UIView()
        circleSuperview.addSubview(circleView)
        circleView.snp.makeConstraints { (make) in
            make.width.equalTo(10)
            make.height.equalTo(circleView.snp.width)
            make.top.greaterThanOrEqualToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        circleSuperview.snp.makeConstraints { (make) in
            make.width.equalTo(20)
        }
        stackView.addArrangedSubview(circleSuperview)
        
        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(14)
            make.center.equalToSuperview()
        }
    }
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        if isSelected {
            everyLabel.textColor = .white
            titleLabel.textColor = .white
            circleView.backgroundColor = .white
            backgroundColor = .gray
        } else {
            everyLabel.textColor = .gray
            titleLabel.textColor = .gray
            circleView.backgroundColor = .gray
            backgroundColor = .secondarySystemBackground
        }
    }
    
    func bind(viewModel: PeriodViewModel) {
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.selected
            .map(setSelected)
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.periodCountHidden
            .bind(to: periodCountTextField.rx.isHidden)
            .disposed(by: disposeBag)

        periodCountTextField.rx.isFirstResponder
            .bind(to: viewModel.isFirstResponder)
            .disposed(by: disposeBag)
        
        (periodCountTextField.rx.text <-> viewModel.periodCount)
            .disposed(by: disposeBag)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        selection.onNext(())
        periodCountTextField.becomeFirstResponder()
    }
}

extension PeriodView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let newText = ((textField.text.orEmpty) as NSString).replacingCharacters(in: range, with: string)
        
        if newText == "0" {
            return false
        }
        
        let textLimit = 3
        if newText.count <= textLimit {
            return true
        }
        
        return false
    }
}
