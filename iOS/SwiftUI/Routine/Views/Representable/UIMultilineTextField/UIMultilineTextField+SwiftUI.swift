//
//  UIMultilineTextField+SwiftUI.swift
//  UIMultilineTextField+SwiftUI
//
//  Created by Vadim Koronchik on 30.07.21.
//

import SwiftUI

struct MultilineTextField: UIViewRepresentable {
    
    @Binding var text: String
    
    let placeholder: String
    let font: UIFont
    
    func makeUIView(context: Context) -> UIMultilineTextField {
        let textField = UIMultilineTextField()
        textField.delegate = context.coordinator
        textField.text = text
        textField.placeholder = placeholder
        textField.font = font
        return textField
    }
    
    func updateUIView(_ uiView: UIMultilineTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UIMultilineTextFieldDelegate {
        
        let text: Binding<String>
        
        init(text: Binding<String>) {
            self.text = text
        }
        
        func multilineTextFieldDidChange(_ textField: UIMultilineTextField) {
            text.wrappedValue = textField.text
        }
    }
}
