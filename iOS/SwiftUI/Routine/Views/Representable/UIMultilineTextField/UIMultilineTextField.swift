//
//  UIMultilineTextField.swift
//  UIMultilineTextField
//
//  Created by Vadim Koronchik on 30.07.21.
//

import UIKit

protocol UIMultilineTextFieldDelegate: AnyObject {
    func multilineTextFieldDidChange(_ textField: UIMultilineTextField)
}

final class UIMultilineTextField: UIView {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
        textView.delegate = self
        textView.textContainer.lineBreakMode = .byWordWrapping
        return textView
    }()
    
    private lazy var placeholderTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textColor = .lightGray
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    var textLimit: Int?
    
    var text: String {
        get { textView.text }
        set {
            textView.text = newValue
            placeholderTextView.isHidden = !textView.text.isEmpty
            invalidateIntrinsicContentSize()
        }
    }
    
    var font: UIFont? {
        get { textView.font }
        set {
            placeholderTextView.font = newValue
            textView.font = newValue
        }
    }
    
    var placeholder: String! {
        get { placeholderTextView.text }
        set { placeholderTextView.text = newValue }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = CGSize(width: textView.frame.size.width, height: .greatestFiniteMagnitude)
        return textView.sizeThatFits(size)
    }
    
    weak var delegate: UIMultilineTextFieldDelegate?
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(textView)
        addSubview(placeholderTextView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        placeholderTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            placeholderTextView.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            placeholderTextView.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            placeholderTextView.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderTextView.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
        ])
    }
}

extension UIMultilineTextField: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.multilineTextFieldDidChange(self)
        placeholderTextView.isHidden = !textView.text.isEmpty
        invalidateIntrinsicContentSize()
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        guard let textLimit = textLimit else { return true }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > textLimit { return false }
        
        return true
    }
}
