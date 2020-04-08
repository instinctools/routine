//
//  PlaceholderTextView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/28/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import Foundation

extension UITextView {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextView }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}

class PlaceholderTextView: UIView {
    
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
    
    var textPublisher: AnyPublisher<String, Never> {
        return textView.textPublisher
    }
    
    var text: String {
        set(value) {
            textView.text = value
            placeholderTextView.isHidden = !value.isEmpty
        }
        get {
            return textView.text
        }
    }
    var placeholder: String {
        set(value) {
            placeholderTextView.text = value
        }
        get {
            return placeholderTextView.text ?? ""
        }
    }
    var font: UIFont? {
        set(value) {
            placeholderTextView.font = value
            textView.font = value
        }
        get {
            return textView.font
        }
    }
    var textLimit: Int?
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(placeholderTextView)
        addSubview(textView)
        
        placeholderTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leading)
            make.top.equalTo(snp.top)
            make.bottom.equalTo(snp.bottom)
            make.trailing.equalTo(snp.trailing)
        }
        
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leading)
            make.top.equalTo(snp.top)
            make.bottom.equalTo(snp.bottom)
            make.trailing.equalTo(snp.trailing)
        }
    }
}

extension PlaceholderTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderTextView.isHidden = !textView.text.isEmpty
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

