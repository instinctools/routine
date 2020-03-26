//
//  TextView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/24/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI

struct TextView: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 30, weight: .medium)
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.autocorrectionType = .no
        textView.delegate = context.coordinator
        return textView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, placeholder: placeholder)
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isEmpty, !placeholder.isEmpty {
            uiView.text = placeholder
            uiView.textColor = UIColor.lightGray
        } else {
            uiView.text = text
        }
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        private var text: Binding<String>
        private var placeholder: String

        init(text: Binding<String>, placeholder: String) {
            self.text = text
            self.placeholder = placeholder
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholder
                textView.textColor = UIColor.lightGray
            }
        }
        
        func textView(_ textView: UITextView,
                      shouldChangeTextIn range: NSRange,
                      replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
}
