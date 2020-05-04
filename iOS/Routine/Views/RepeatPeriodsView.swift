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
    
    func setup(with periods: [Period], selectedPeriod: Period?, count: String?) {
        periodViews.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        periods.forEach { (period) in
            let periodView = PeriodView()
            periodView.didSelect = { (period, count) in
                self.didSelect?(period, count)
            }
            if period == selectedPeriod {
                let periodCount = count ?? ""
                periodView.setup(with: PeriodViewModel(period: period, periodCount: Int(periodCount) ?? 0), isSelected: true)
            } else {
                periodView.setup(with: PeriodViewModel(period: period, periodCount: nil), isSelected: false)
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

//struct RepeatPeriodsView: View {
//        
//    @State var selectedPeriod: Period?
//    @State var periodCount: String = ""
//    @State var textFieldWidth: CGFloat = 0
//    @State var isFirstResponder = false
//    
//    var onSelect: (_ period: Period, _ count: String) -> Void
//    
//    var body: some View {
//        VStack {
//            LabelledDivider(label: "Repeat")
//            ForEach(Period.allCases, id: \.rawValue) { (period) in
//                HStack {
//                    Text("Every")
//                        .font(Font.system(size: 24, weight: .medium))
//                        .foregroundColor(self.foregroundColor(forPeriod: period))
//                        .padding([.vertical, .leading])
//                    
//                    if self.isSelected(period: period) && (self.periodCount != "" || self.isFirstResponder) {
//                        DynamicTextFieldRepresentable(
//                            textLimit: 4,
//                            font: UIFont.systemFont(ofSize: 22, weight: .medium),
//                            textColor: self.foregroundColor(forPeriod: period),
//                            keyboardType: .numberPad,
//                            text: self.$periodCount,
//                            width: self.$textFieldWidth,
//                            isFirstResponder: self.$isFirstResponder
//                        )
//                        .frame(width: self.textFieldWidth)
//                        .padding(.vertical)
//                        .padding(.leading, 4)
////                        .alignmentGuide(.center, computeValue: { $0.height })
//                    }
//                    
//                    Text(period.title(periodCount: Int(self.periodCount) ?? 0))
//                        .font(Font.system(size: 24, weight: .medium))
//                        .foregroundColor(self.foregroundColor(forPeriod: period))
//                        .padding([.vertical, .trailing])
//                    
//                    Spacer()
//                    
//                    Circle()
//                        .frame(width: 12)
//                        .foregroundColor(self.foregroundColor(forPeriod: period))
//                        .padding()
//                }
//                .background(self.backgroundColor(forPeriod: period))
//                .cornerRadius(12)
//                .frame(height: 44)
//                .padding(.vertical, 8)
//                .onTapGesture {
//                    if self.selectedPeriod != period {
//                        self.periodCount = ""
//                    }
//                    self.isFirstResponder = true
//                    self.selectedPeriod = period
//                    self.onSelect(period, self.periodCount)
//                }
//            }
//            Spacer()
//         }
//    }
//    
//    private func isSelected(period: Period) -> Bool {
//        return period == selectedPeriod
//    }
//    
//    private func foregroundColor(forPeriod period: Period) -> Color {
//        return Color(foregroundColor(forPeriod: period))
//    }
//    
//    private func foregroundColor(forPeriod period: Period) -> UIColor {
//        return isSelected(period: period) ? UIColor.white : UIColor.gray
//    }
//    
//    private func backgroundColor(forPeriod period: Period) -> Color {
//        return isSelected(period: period) ? Color.gray : .init(UIColor.secondarySystemBackground)
//    }
//}
//
//struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepeatPeriodsView(onSelect: { (_, _) in})
//    }
//}
//
//struct DynamicTextFieldRepresentable: UIViewRepresentable {
//    
//    let textLimit: Int?
//    let font: UIFont
//    let textColor: UIColor
//    let keyboardType: UIKeyboardType
//    
//    @Binding var text: String
//    @Binding var width: CGFloat
//    @Binding var isFirstResponder: Bool
//
//    func makeUIView(context: UIViewRepresentableContext<DynamicTextFieldRepresentable>) -> UITextField {
//        let textField = DynamicTextField()
//        textField.delegate = context.coordinator
//        textField.font = font
//        textField.textColor = textColor
//        textField.keyboardType = keyboardType
//        textField.textAlignment = .right
////        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        return textField
//    }
//    
//    func updateUIView(_ uiView: UITextField,
//                      context: UIViewRepresentableContext<DynamicTextFieldRepresentable>) {
//        
//        DispatchQueue.main.async {
//            self.width = uiView.intrinsicContentSize.width
//        }
//        
//        if isFirstResponder && !uiView.isFirstResponder {
//            uiView.becomeFirstResponder()
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(textLimit: textLimit,
//                           text: $text,
//                           width: $width,
//                           isFirstResponder: $isFirstResponder)
//    }
//    
//    final class Coordinator: NSObject, UITextFieldDelegate {
//        
//        var text: Binding<String>
//        var width: Binding<CGFloat>
//        var isFirstResponder: Binding<Bool>
//        private let textLimit: Int?
//        
//        
//        init(textLimit: Int?, text: Binding<String>, width: Binding<CGFloat>, isFirstResponder: Binding<Bool>) {
//            self.textLimit = textLimit
//            self.text = text
//            self.width = width
//            self.isFirstResponder = isFirstResponder
//        }
//        
//        func textField(_ textField: UITextField,
//                       shouldChangeCharactersIn range: NSRange,
//                       replacementString string: String) -> Bool {
//            
//            let newText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
//            
//            guard let textLimit = textLimit else {
//                text.wrappedValue = newText
//                return true
//            }
//            
//            if newText.count > textLimit { return false }
//            text.wrappedValue = newText
//            
//            return true
//        }
//        
//        func textFieldDidEndEditing(_ textField: UITextField) {
//            isFirstResponder.wrappedValue = false
//        }
//    }
//}

class DynamicTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextChangeNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextChangeNotification()
    }

    func setupTextChangeNotification() {
        NotificationCenter.default.addObserver(
            forName: UITextField.textDidChangeNotification,
            object: self,
            queue: nil) { (notification) in
                UIView.animate(withDuration: 0.05, animations: {
                    self.invalidateIntrinsicContentSize()
                })
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var intrinsicContentSize: CGSize {
        if isEditing {
            if let text = text, !text.isEmpty {
                let string = text as NSString
                var size = string.size(withAttributes: typingAttributes)
                size.width += 10
                return size
            } else {
                return super.intrinsicContentSize
            }
        } else {
            return super.intrinsicContentSize
        }
    }
}
