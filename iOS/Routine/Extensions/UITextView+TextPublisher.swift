//
//  UITextView+TextPublisher.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 4/20/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Combine

extension UITextView {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextView }
            .map { $0.text.orEmpty }
            .eraseToAnyPublisher()
    }
}
